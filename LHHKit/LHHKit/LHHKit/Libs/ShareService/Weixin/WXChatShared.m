//
//  RenRenCiShanJia
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//


#import "WXChatShared.h"

#pragma mark -

@interface WXChatShared ()

@property (nonatomic, strong) NSNumber *		errorCode;
@property (nonatomic, strong) NSString *		errorDesc;

- (void)openWeixin;
- (void)openStore;

- (void)clearPost;
- (void)clearError;

@end

@implementation WXChatShared

SingletonImplemention(WXChatShared)

#pragma mark -

+ (void)load
{
	[AppService addService:[self sharedWXChatShared]];
}

- (void)powerOn
{
	[WXApi registerApp:self.appId];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ( url )
    {
        for (NSString * key in options) {
            if ( [key hasPrefix:@"com.tencent.xin"] )
            {
                [WXApi handleOpenURL:url delegate:self];
            }
        }
    }
    
    return YES;
}

#else

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	if ( url )
	{
		if ( [sourceApplication hasPrefix:@"com.tencent.xin"] )
		{
            [WXApi handleOpenURL:url delegate:self];
		}
	}

	return YES;
}

#endif

#pragma mark -

- (WXChatShared_Config *)config
{
    return [WXChatShared_Config sharedWXChatShared_Config];
}

#pragma mark - 得到用户信息

- (void)getuserInfo
{
	if ( NO == [WXApi isWXAppInstalled] )
	{
		return;
	}

	SendAuthReq* req =[[SendAuthReq alloc ] init];
	req.scope = @"snsapi_userinfo";
	req.state = @"1024";

	// 第三方向微信终端发送一个SendAuthReq消息结构
	[WXApi sendReq:req];
}

#pragma mark -

- (void)shareFriend
{
	[self share:WXSceneSession];
}

- (void)shareTimeline
{
	[self share:WXSceneTimeline];
}

+ (BOOL)isWxAppInstalled
{
	return [WXApi isWXAppInstalled];
}

- (void)share:(enum WXScene)scene
{
	if ( NO == [WXApi isWXAppInstalled] )
	{
        NSLog(@"未安装微信客户端");
		return;
	}

	if ( self.post.photo || self.post.url )
	{
		SendMessageToWXReq *	req = [[SendMessageToWXReq alloc] init];
		WXMediaMessage *		message = [WXMediaMessage message];

		if ( self.post.photo )
		{
			NSData * thumbData = nil;

			if ( [self.post.photo isKindOfClass:[UIImage class]] )
			{
				// 计算当前图片的大小，如果超过32k那么就进行压缩
                thumbData = UIImageJPEGRepresentation(self.post.photo, 1.0);
                
                // 计算当前图片的大小，如果超过32k那么就进行压缩
                if ( thumbData.length > 32000 )
                {
                    CGFloat compressionRatio = 32000.0 / thumbData.length;
                    thumbData = UIImageJPEGRepresentation(self.post.photo, compressionRatio);
                }
                if ( thumbData.length > 32000 )
                {
                    thumbData = [self reSizeImageData:self.post.photo maxImageSize:100 maxFileSizeWithKB:32000];
                }
			}
			else if ( [self.post.photo isKindOfClass:[NSData class]] )
			{
				thumbData = (NSData *)self.post.photo;
			}
            
            if (thumbData.length >= 32000)
            {
                [message setThumbImage:[UIImage imageNamed:@"default_share"]];
            }
            else
            {
                [message setThumbData:thumbData];
            }
		}

		if ( self.post.url )
		{
			WXWebpageObject * webObject = [WXWebpageObject object];
			
			webObject.webpageUrl = self.post.url;
			
			message.mediaObject = webObject;
		}
	
		message.title = self.post.title && self.post.title.length ? self.post.title : self.post.text;
		message.description = self.post.text;

		req.message = message;
		req.bText = NO;
		req.scene = scene;

		BOOL succeed = [WXApi sendReq:req];

		if ( succeed )
		{
			[self notifyShareBegin];
		}
		else
		{
			[self notifyShareFailed];
		}
	}
	else if ( self.post.text )
	{
		SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
		
		if ( self.post.title && self.post.title.length )
		{
			req.text = self.post.title;
		}
		
		if ( self.post.text && self.post.text.length )
		{
			req.text = self.post.text;
		}
		
		req.bText = YES;
		req.scene = scene;
		
		BOOL succeed = [WXApi sendReq:req];
		if ( succeed )
		{
			[self notifyShareBegin];
		}
		else
		{
			[self notifyShareFailed];
		}
	}
	else
	{
		[self notifyShareFailed];
	}

}

- (void)clearPost
{
	[self.post clear];
}

#pragma mark -

- (void)notifyShareBegin
{
	if ( self.whenShareBegin )
	{
		self.whenShareBegin();
	}
	else if ( [ServiceShare sharedServiceShare].whenShareBegin )
	{
		[ServiceShare sharedServiceShare].whenShareBegin();
	}
}

- (void)notifyShareSucceed
{
	if ( self.whenShareSucceed )
	{
		self.whenShareSucceed();
	}
	else if ( [ServiceShare sharedServiceShare].whenShareSucceed )
	{
		[ServiceShare sharedServiceShare].whenShareSucceed();
	}

	[self clearPost];
}

- (void)notifyShareFailed
{
	if ( self.whenShareFailed )
	{
		self.whenShareFailed();
	}
	else if ( [ServiceShare sharedServiceShare].whenShareFailed )
	{
		[ServiceShare sharedServiceShare].whenShareFailed();
	}
	
	[self clearPost];
}

- (void)notifyShareCancelled
{
    if ( self.whenShareCancelled )
    {
        self.whenShareCancelled();
    }
    else if ( [ServiceShare sharedServiceShare].whenShareCancelled )
    {
        [ServiceShare sharedServiceShare].whenShareCancelled();
    }
    
    [self clearPost];
}

#pragma mark -

- (void)notifyGetUserInfoBegin
{
	if ( self.whenGetUserInfoBegin )
	{
		self.whenGetUserInfoBegin();
	}
	else if ( [ServiceShare sharedServiceShare].whenGetUserInfoBegin )
	{
		[ServiceShare sharedServiceShare].whenGetUserInfoBegin();
	}
}

- (void)notifyGetUserInfoSucceed
{
	ACCOUNT * account = [[ACCOUNT alloc] init];
	account.socialVendor = SOCIAL_VENDOR_Wechat;
	account.access_token = self.accessToken;
	account.open_id = self.openid;

	if ( self.whenGetUserInfoSucceed )
	{
        self.whenGetUserInfoSucceed(account);
	}
	else if ( [ServiceShare sharedServiceShare].whenGetUserInfoSucceed )
	{
		[ServiceShare sharedServiceShare].whenGetUserInfoSucceed(account);
	}
}

- (void)notifyGetUserInfoFailed
{
	if ( self.whenGetUserInfoFailed )
	{
		self.whenGetUserInfoFailed();
	}
	else if ( [ServiceShare sharedServiceShare].whenGetUserInfoFailed )
	{
		[ServiceShare sharedServiceShare].whenGetUserInfoFailed();
	}
}

- (void)notifyGetUserInfoCancelled
{
    if ( self.whenGetUserInfoCancelled )
    {
        self.whenGetUserInfoCancelled();
    }
    else if ( [ServiceShare sharedServiceShare].whenGetUserInfoCancelled )
    {
        [ServiceShare sharedServiceShare].whenGetUserInfoCancelled();
    }
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq*)req
{
	
}

- (void)onResp:(BaseResp*)resp
{
	if ( [resp isKindOfClass:[SendMessageToWXResp class]] )
	{
		if ( WXSuccess == resp.errCode )
		{
			[self notifyShareSucceed];
		}
		else if ( WXErrCodeUserCancel == resp.errCode )
		{
			[self notifyShareCancelled];
		}
		else
		{
			[self notifyShareFailed];
		}
	}
	else if ( [resp isKindOfClass:[SendAuthResp class]] )
	{
		SendAuthResp *aresp = (SendAuthResp *)resp;

		if ( aresp.errCode== 0)
		{
			self.weiXincode = aresp.code;

			if ( self.weiXincode )
			{
				[self getAccessToken];
			}
			else
			{
				[self notifyGetUserInfoFailed];
			}
		}
		else
		{
			[self notifyGetUserInfoCancelled];
		}
	}
}

- (void)getAccessToken
{
	NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", self.appId, self.appKey, self.weiXincode];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

		NSURL *zoneUrl = [NSURL URLWithString:url];
		NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
		NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];

		dispatch_async(dispatch_get_main_queue(), ^{
			if ( data )
			{
				NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

				self.accessToken = [dic objectForKey:@"access_token"];
				self.openid = [dic objectForKey:@"openid"];
				self.expiresIn = [dic objectForKey:@"expires_in"];

				[self getUserAvatorInfo];

				if ( self.accessToken )
				{
					[self notifyGetUserInfoSucceed];
				}
				else
				{
					[self notifyGetUserInfoFailed];
				}
			}
			else
			{
				[self notifyGetUserInfoFailed];
			}
		});
	});
}

- (void)getUserAvatorInfo
{
	NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", self.accessToken, self.openid];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSURL *zoneUrl = [NSURL URLWithString:url];
		NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
		NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
		
		dispatch_async(dispatch_get_main_queue(), ^{

			NSString * avatarKey = [NSString stringWithFormat:@"avatar-%@", @"Auth"];
			if ( data )
			{
				NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                // 获取用户头像
                [LHHCache switchCacheWithName:nil];
                [LHHCache setObject:dic[@"headimgurl"] forKey:avatarKey];
            }
            else
            {
                // 头像获取失败，那么置空
                [LHHCache switchCacheWithName:nil];
                [LHHCache removeObjectForKey:avatarKey];
			}
		});
	});

}

#pragma mark -

- (void)openWeixin
{
	[WXApi openWXApp];
}

- (void)openStore
{
#if !TARGET_IPHONE_SIMULATOR
	
	NSString * url = [WXApi getWXAppInstallUrl];
	if ( url && url.length )
	{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
#pragma clang diagnostic pop
        }
	}
	
#endif	// #if !TARGET_IPHONE_SIMULATOR
}

- (void)clearError
{
	self.errorCode = nil;
	self.errorDesc = nil;
}

- (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxFileSizeWithKB:(CGFloat)maxFileSize
{
    
    if (maxFileSize <= 0.0)  maxFileSize = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / maxImageSize;
    CGFloat tempWidth = newSize.width / maxImageSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxFileSize && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
    }
    
    return imageData;
}

@end
