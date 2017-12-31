//
//  RenRenCiShanJia
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//


#import "TencentOpenShared.h"

@implementation TencentOpenShared

SingletonImplemention(TencentOpenShared)

#pragma mark -

+ (void)load
{
	[AppService addService:[self sharedTencentOpenShared]];
}

- (void)powerOn
{
	self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:self.appId andDelegate:self];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ( url )
    {
        for (NSString * key in options) {
            if ( [key isEqualToString:@"com.tencent.mqq"] ||
                [key isEqualToString:@"com.tencent.mipadqq"])
            {
                [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)self];
                [TencentOAuth CanHandleOpenURL:url];
                [TencentOAuth HandleOpenURL:url];
            }

        }
    }
    
    return YES;
}

#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ( [sourceApplication isEqualToString:@"com.tencent.mqq"] ||
        [sourceApplication isEqualToString:@"com.tencent.mipadqq"])
	{
		[QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)self];
		[TencentOAuth CanHandleOpenURL:url];
		[TencentOAuth HandleOpenURL:url];
	}

	return YES;
}

#endif

#pragma mark - 得到用户信息

- (void)getUserInfo
{
	if ( NO == [TencentOAuth iphoneQQInstalled] )
	{
		return;
	}

	NSArray * permissions = @[kOPEN_PERMISSION_GET_INFO,
							  kOPEN_PERMISSION_GET_USER_INFO,
							  kOPEN_PERMISSION_GET_SIMPLE_USER_INFO
							 ];

	[self.tencentOAuth authorize:permissions inSafari:NO];
}

#pragma mark -

- (void)shareQq
{
	[self share:TencentOpenSenceQQ];
}

- (void)shareQzone
{
	[self share:TencentOpenSenceQZone];
}

+ (BOOL)isTencentAppInstalled
{
	return [TencentOAuth iphoneQQInstalled];
}

#pragma mark -

- (void)share:(TencentOpenSence)scene
{
	//分享到QQ
	if ( NO == [TencentOAuth iphoneQQInstalled] )
	{
        NSLog(@"未安装QQ客户端");
		return;
	}

	if ( self.post.photo || self.post.url )
	{
		NSData * imageData = nil;
		
		if ( [self.post.photo isKindOfClass:[NSData class]] )
		{
			imageData = self.post.photo;
		}
		else if ( [self.post.photo isKindOfClass:[UIImage class]] )
		{
			imageData = UIImageJPEGRepresentation(self.post.photo, 0.6);
		}

		NSString * title = self.post.title;

		if ( title.length > 140 )
		{
			title = [title substringToIndex:140];
		}
		
		NSString * text = self.post.text;
		
		if ( text.length > 140 )
		{
			text = [text substringToIndex:140];
		}

		QQApiNewsObject *newsObj ;

		if ( [self.post.photo isKindOfClass:[NSString class]] )
		{
			newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.post.url ? : @""]
											   title:title ? : @"分享"
										 description:text ? : @"分享"
									 previewImageURL:[NSURL URLWithString:self.post.photo]];
		}
		else
		{
			newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.post.url ? : @""]
											   title:title ? : @"分享"
										 description:text ? : @"分享"
									previewImageData:imageData];
		}

		SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];

		QQApiSendResultCode sent = 0;

		if ( TencentOpenSenceQZone == scene )
		{
			//分享到QZone
			sent = [QQApiInterface SendReqToQZone:req];
		}
		else if ( TencentOpenSenceQQ == scene )
		{
			//分享到QQ
			sent = [QQApiInterface sendReq:req];
		}

		[self handleSendResult:sent];
	}
	else
	{
		[self notifyShareFailed];
	}

}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
	switch (sendResult)
	{
		case EQQAPIAPPNOTREGISTED:
		{
			[self notifyShareFailed];
			break;
		}
		case EQQAPIMESSAGECONTENTINVALID:
		case EQQAPIMESSAGECONTENTNULL:
		case EQQAPIMESSAGETYPEINVALID:
		{
			[self notifyShareFailed];
			break;
		}
		case EQQAPIQQNOTINSTALLED:
		{
			[self notifyShareFailed];
			break;
		}
		case EQQAPIQQNOTSUPPORTAPI:
		{
			[self notifyShareFailed];
			break;
		}
		case EQQAPISENDFAILD:
		{
			[self notifyShareFailed];
			break;
		}
		case EQQAPIQZONENOTSUPPORTTEXT:
		case EQQAPIQZONENOTSUPPORTIMAGE:
		{
			[self notifyShareFailed];
			break;
		}
		default:
			break;
	}
}

#pragma mark - 

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

- (void)clearPost
{
	[self.post clear];
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
	account.socialVendor = SOCIAL_VENDOR_QQ;
	account.access_token = self.tencentOAuth.accessToken;
	account.open_id = self.tencentOAuth.openId;
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

#pragma mark - QQApiDelegate

- (void)onReq:(QQBaseReq*)req
{
	
}

- (void)onResp:(QQBaseReq*)resp
{
	switch ( resp.type )
	{
		case ESENDMESSAGETOQQRESPTYPE:
		{
			SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;

			if ( sendResp.result.integerValue == 0 )
			{
				[self notifyShareSucceed];
			}
            else if ( sendResp.result.integerValue == -4 )
            {
                [self notifyShareCancelled];
            }
			else
			{
				[self notifyShareFailed];
			}
			break;
		}
		default:
		{
			break;
		}
	}
}

- (void)isOnlineResponse:(NSDictionary *)response
{
	
}

- (void)tencentDidLogin
{
	if ( self.tencentOAuth.accessToken && self.tencentOAuth.accessToken.length )
	{
		// 获取用户具体信息
		[self.tencentOAuth getUserInfo];
	}
	else
	{
		[self  notifyGetUserInfoFailed];
	}
}

// 没有网络
- (void)tencentDidNotNetWork
{
	[self  notifyGetUserInfoFailed];
}

// 登录失败  用户取消
- (void)tencentDidNotLogin:(BOOL)cancelled
{
	if ( cancelled )
	{
		[self  notifyGetUserInfoCancelled];
	}
	else
	{
		[self  notifyGetUserInfoFailed];
	}
}

// 获取用户具体信息的回调
- (void)getUserInfoResponse:(APIResponse*) response
{
	NSString * avatarKey = [NSString stringWithFormat:@"avatar-%@", @"Auth"];

	if ( response.detailRetCode == kOpenSDKErrorSuccess )
	{
		self.responseDic = response.jsonResponse;

		// 获取用户头像
        [LHHCache switchCacheWithName:nil];
        [LHHCache setObject:self.responseDic[@"figureurl_qq_2"] forKey:avatarKey];

		[self notifyGetUserInfoSucceed];
	}
	else
	{
		// 头像获取失败，那么置空

        [LHHCache switchCacheWithName:nil];
        [LHHCache removeObjectForKey:avatarKey];
        
		[self  notifyGetUserInfoFailed];
	}
}

@end
