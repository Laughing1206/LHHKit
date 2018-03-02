//
//  RenRenCiShanJia
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//


#define KAppKey @"735351141"
#define KRedirectURI @"https://api.weibo.com/oauth2/default.html"

#import "SinaWeibo.h"

@implementation SinaWeibo

SingletonImplemention(SinaWeibo)

#pragma mark -

+ (void)load
{
	[AppService addService:[self sharedSinaWeibo]];
}

- (void)powerOn
{
	[WeiboSDK enableDebugMode:YES];
	[WeiboSDK registerApp:self.appKey];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [WeiboSDK handleOpenURL:url delegate:self];
    return YES;
}

#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	[WeiboSDK handleOpenURL:url delegate:self];
	return YES;
}
#endif

#pragma mark -

- (void)share
{
	if ( [WeiboSDK isWeiboAppInstalled] )
	{
		WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];

		request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
							 @"Other_Info_1": [NSNumber numberWithInt:123],
							 @"Other_Info_2": @[@"obj1", @"obj2"],
							 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
		[WeiboSDK sendRequest:request];

		return;
	}
	else
	{
        NSLog(@"未安装新浪微博客户端");
	}
}

+ (BOOL)isWeiboAppInstalled
{
	return [WeiboSDK isWeiboAppInstalled];
}

#pragma mark - 

- (BOOL)isAuthorized
{
	return self.isExpired && self.accessToken && self.uid;
}

- (BOOL)isExpired
{
	if ( self.expiresIn )
	{
	}

	return YES;
}

#pragma mark - 关注账号

- (void)followWithName:(NSString *)name
{
	if ( [self isAuthorized] )
	{
		[self followName:name];
	}
	else
	{
		WBAuthorizeRequest *request = [WBAuthorizeRequest request];
		request.redirectURI = self.redirectUrl;
		request.scope = @"all";
		request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
							 @"Other_Info_1": [NSNumber numberWithInt:123],
							 @"Other_Info_2": @[@"obj1", @"obj2"],
							 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
		[WeiboSDK sendRequest:request];
	}
}

- (void)followName:(NSString *)name
{
	[self notifyFollowBegin];

	NSDictionary * dict = @{@"screen_name":name,
							@"access_token":_accessToken};

	[WBHttpRequest requestWithURL:@"https://api.weibo.com/2/friendships/create.json"
					   httpMethod:@"POST"
						   params:dict
						 delegate:self
						  withTag:nil];
}

#pragma mark - 得到用户信息

- (void)getUserInfo
{
	if ( [WeiboSDK isWeiboAppInstalled] )
	{
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = self.redirectUrl;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
			
        [WeiboSDK sendRequest:request];
	}
}

- (WBMessageObject *)messageToShare
{
	WBMessageObject *message = [WBMessageObject message];

	NSString * text = @"";

	if ( self.post.title && self.post.title.length )
	{
		text = self.post.title;
	}

	if ( self.post.text && self.post.text.length )
	{
		text = [NSString stringWithFormat:@"%@\n%@", text, self.post.text];
	}

	NSInteger index = 140 - self.post.url.length;

	if ( text.length > index )
	{
		text = [text substringToIndex:index];
	}

	if ( self.post.url && self.post.url.length )
	{
		if ( ![self.post.url hasPrefix:@"http:"] )
		{
			text = [NSString stringWithFormat:@"%@ http://%@", text, self.post.url];
		}
		else
		{
			text = [NSString stringWithFormat:@"%@ %@", text, self.post.url];
		}
	}

	if ( text.length > 140 )
	{
		text = [text substringToIndex:140];
	}

    if ( self.post.photo && ![self.post.photo isKindOfClass:[NSString class]] )
    {
		WBImageObject * imageObject = [WBImageObject object];

		imageObject.imageData = self.post.photo;

		if ( [self.post.photo isKindOfClass:[UIImage class]] )
		{
			imageObject.imageData = UIImagePNGRepresentation( self.post.photo );
		}
		else if ( [self.post.photo isKindOfClass:[NSData class]] )
		{
			imageObject.imageData = self.post.photo;
		}

		// 分享图片
		message.imageObject = imageObject;
	}

	// 分享文字
	message.text = text;

	return message;
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
	[self clearPost];

	if ( self.whenShareSucceed )
	{
		self.whenShareSucceed();
	}
	else if ( [ServiceShare sharedServiceShare].whenShareSucceed )
	{
		[ServiceShare sharedServiceShare].whenShareSucceed();
	}
}

- (void)notifyShareFailed
{
	[self clearPost];

	if ( self.whenShareFailed )
	{
		self.whenShareFailed();
	}
	else if ( [ServiceShare sharedServiceShare].whenShareFailed )
	{
		[ServiceShare sharedServiceShare].whenShareFailed();
	}
}

- (void)notifyShareCancelled
{
    [self clearPost];
    
    if ( self.whenShareCancelled )
    {
        self.whenShareCancelled();
    }
    else if ( [ServiceShare sharedServiceShare].whenShareCancelled )
    {
        [ServiceShare sharedServiceShare].whenShareCancelled();
    }
}

#pragma mark -

- (void)notifyFollowBegin
{
	if ( self.whenFollowBegin )
	{
		self.whenFollowBegin();
	}
	else if ( [ServiceShare sharedServiceShare].whenFollowBegin )
	{
		[ServiceShare sharedServiceShare].whenFollowBegin();
	}
}

- (void)notifyFollowSucceed
{	
	if ( self.whenFollowSucceed )
	{
		self.whenFollowSucceed();
	}
	else if ( [ServiceShare sharedServiceShare].whenFollowSucceed )
	{
		[ServiceShare sharedServiceShare].whenFollowSucceed();
	}
}

- (void)notifyFollowFailed
{
	if ( self.whenFollowFailed )
	{
		self.whenFollowFailed();
	}
	else if ( [ServiceShare sharedServiceShare].whenFollowFailed )
	{
		[ServiceShare sharedServiceShare].whenFollowFailed();
	}
}

- (void)notifyFollowCancelled
{
    if ( self.whenFollowCancelled )
    {
        self.whenFollowCancelled();
    }
    else if ( [ServiceShare sharedServiceShare].whenFollowCancelled )
    {
        [ServiceShare sharedServiceShare].whenFollowCancelled();
    }
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
	account.socialVendor = SOCIAL_VENDOR_WEIBO;
	account.access_token = self.accessToken;
	account.open_id = self.uid;

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

#pragma mark - 

- (void)clearPost
{
	[self.post clear];
}

#pragma mark - weiboDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
	if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
	{
	}
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
	if ( [response isKindOfClass:WBSendMessageToWeiboResponse.class] )
	{
		if ( WeiboSDKResponseStatusCodeSuccess == response.statusCode )
		{
			[self notifyShareSucceed];
		}
		else
		{
			[self failedDescWithresponse:response];
		}
	}
	else if ( [response isKindOfClass:WBAuthorizeResponse.class] )
	{
		if ( WeiboSDKResponseStatusCodeSuccess == response.statusCode )
		{
			self.uid = response.userInfo[@"uid"];
			self.accessToken = response.userInfo[@"access_token"];
			self.expiresIn = response.userInfo[@"expires_in"];
			self.remindIn = response.userInfo[@"remind_in"];

			[self getAccessToken];

			[self saveCache];

			// 获取信息成功
			[self notifyGetUserInfoSucceed];
		}
        else if ( WeiboSDKResponseStatusCodeUserCancel == response.statusCode )
        {
            // 获取信息取消
            [self notifyGetUserInfoCancelled];
        }
		else
		{
			// 获取信息失败
			[self notifyGetUserInfoFailed];
		}
	}
}

- (void)getAccessToken
{
	NSString *url =[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@", self.uid, self.accessToken];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {

		NSURL *zoneUrl = [NSURL URLWithString:url];
		NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
		NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
		
		dispatch_async(dispatch_get_main_queue(), ^ {
			NSString * avatarKey = [NSString stringWithFormat:@"avatar-%@", @"Auth"];
			if ( data )
			{
				NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
				
                // 获取用户头像
                [LHHCache switchCacheWithName:nil];
                [LHHCache setObject:dic[@"profile_image_url"] forKey:avatarKey];
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

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
	NSDictionary * resultDic = [self dictionaryWithJsonString:result];

	NSString * error = resultDic[@"error"];

	if ( error && error.length )
	{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"关注提示"
                                                             message:error
                                                            delegate:self
                                                   cancelButtonTitle:@"确认"
                                                   otherButtonTitles:nil, nil];
		[alertView show];
		[self notifyFollowFailed];
	}
	else
	{
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"关注提示"
                                                             message:@"成功"
                                                            delegate:self
                                                   cancelButtonTitle: @"确认"
                                                   otherButtonTitles:nil, nil];
#pragma clang diagnostic pop
		[alertView show];
		[self notifyFollowSucceed];
	}
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
	NSLog(@"数据获取失败，请检查您的网络");
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
	if (jsonString == nil) {
		return nil;
	}
	
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	NSError *err;
	NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
														options:NSJSONReadingMutableContainers
														  error:&err];
	if(err) {
		return nil;
	}
	return dic;
}

#pragma mark -

- (void)failedDescWithresponse:(WBBaseResponse *)response
{
	switch (response.statusCode) {
		case WeiboSDKResponseStatusCodeUserCancel:
		{
            [self notifyShareCancelled];
		}
			break;
		case WeiboSDKResponseStatusCodeAuthDeny:
		{
            [self notifyShareFailed];
		}
			break;
		case WeiboSDKResponseStatusCodeUnsupport:
		{
            [self notifyShareFailed];
		}
			break;
		default:
			break;
	}
}

- (NSDate *)asNSDate:(NSString *)date
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
	[format setLocale:enLocale];

	[format setDateFormat:@"yyyy-HH-dd HH:mm:ss"];
	NSDate *dateTime = [format dateFromString:date];

	return dateTime;
}

- (NSString *)asNSString:(NSDate *)date
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
	[format setLocale:enLocale];

	[format setDateFormat:@"yyyy-HH-dd HH:mm:ss"];
	NSString * dateString = [format stringFromDate:date];
	return dateString;
}

#pragma mark -

- (void)saveCache
{
	[[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[[NSUserDefaults standardUserDefaults] setObject:self.expiresIn forKey:@"expiresIn"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[[NSUserDefaults standardUserDefaults] setObject:self.remindIn forKey:@"remindIn"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[[NSUserDefaults standardUserDefaults] setObject:self.uid forKey:@"uid"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadCache
{
	self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	self.expiresIn   = [[NSUserDefaults standardUserDefaults] objectForKey:@"expiresIn"];
	self.remindIn    = [[NSUserDefaults standardUserDefaults] objectForKey:@"remindIn"];
	self.uid		 = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
}

@end
