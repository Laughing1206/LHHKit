//
//   ___           ___        ___      ___        ___
//  /\  \         /\  \      /\  \    /\  \      /\  \
//  \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//   \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//    \ \  \______  \ \  \     \ \  \   \ \  \     \ \  \
//     \ \________\  \ \__\     \ \__\   \ \__\     \ \__\
//      \/________/   \/__/      \/__/    \/__/      \/__/
//
//  欢欢为人民服务
//  有问题请联系我，http://www.jianshu.com/u/3c6ff28fdc63
//
// -----------------------------------------------------------------------------

#import "ServiceWechatPay.h"

#pragma mark -

NSString * const WXChatPaySucceedNotification = @"WXChatPaySucceedNotification";
NSString * const WXChatPayFailedNotification = @"WXChatPayFailedNotification";
NSString * const WXChatPayCanceledNotification = @"WXChatPayCanceledNotification";

#pragma mark -

@implementation ServiceWechatPay

SingletonImplemention(ServiceWechatPay)

#pragma mark -

+ (void)load
{
	[AppService addService:[self sharedServiceWechatPay]];
}

- (void)powerOn
{
	[WXApi registerApp:self.config.appId];
}

#pragma mark -

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

#pragma mark -

- (ServiceWechatPayConfig *)config
{
    return [ServiceWechatPayConfig sharedServiceWechatPayConfig];
}

#pragma mark - pay

- (ServiceBlock)PAY
{
    ServiceBlock block = ^ void ( void )
    {
        [self pay];
    };
    
    return [block copy];
}

- (void)pay
{
    if ( [WXApi isWXAppInstalled] )
    {
        if ( self.config.prepayId )
        {
            PayReq * request   = [[PayReq alloc] init];
            request.openID    = self.config.appId;
            request.partnerId = self.config.partnerId;
            request.prepayId  = self.config.prepayId;
            request.package   = self.config.package;
            request.nonceStr  = self.config.nonceStr;
            request.timeStamp = self.config.timestamp.intValue;
            request.sign      = self.config.sign;

            [WXApi sendResp:(BaseResp *)request];
        }
    }
    else
    {
        NSLog(@"%@",@"无法支付");
    }
}

#pragma mark -

- (void)onResp:(BaseResp*)resp
{
    if ( [resp isKindOfClass:[PayResp class]] )
    {
        if ( WXSuccess == resp.errCode )
        {
            [self notifyPaySucceed];
        }
        else if ( WXErrCodeUserCancel == resp.errCode )
        {
            [self notifyPayCancelled];
        }
        else
        {
            [self notifyPayFailed];
        }
    }
}

#pragma mark -

- (void)notifyPayBegin
{
    if ( self.whenWaiting )
    {
        self.whenWaiting();
    }
}

- (void)notifyPaySucceed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WXChatPaySucceedNotification object:nil];
    
    if ( self.whenSucceed )
    {
        self.whenSucceed();
    }
    
    [self clearOrder];
}

- (void)notifyPayFailed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WXChatPayFailedNotification object:nil];
    
    if ( self.whenFailed )
    {
        self.whenFailed();
    }
    
    [self clearOrder];
}

- (void)notifyPayCancelled
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WXChatPayCanceledNotification object:nil];
    
    if ( self.whenCancel )
    {
        self.whenCancel();
    }
    
    [self clearOrder];
}

#pragma mark -

- (void)clearOrder
{
    self.whenCancel = nil;
    self.whenWaiting = nil;
    self.whenSucceed = nil;
    self.whenFailed = nil;
}

@end
