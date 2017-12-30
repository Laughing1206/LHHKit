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

#import "ServiceUnionPay.h"

#pragma mark -

NSString * const UnionPaySucceedNotification = @"UnionPaySucceedNotification";
NSString * const UnionPayFailedNotification = @"UnionPayFailedNotification";
NSString * const UnionPayCanceledNotification = @"UnionCanceledNotification";

#pragma mark -

static NSString * const kUPPayModeDistrbution = @"00"; // 正式环境
static NSString * const kUPPayModeDevelopment = @"01"; // 测试环境

#pragma mark -

@implementation ServiceUnionPay

SingletonImplemention(ServiceUnionPay)

#pragma mark -

- (ServiceUnionPayConfig *)config
{
    return [ServiceUnionPayConfig sharedServiceUnionPayConfig];
}

#pragma mark -

- (void)payInViewController:(UIViewController *)viewController
{
    [UPPayPlugin startPay:self.config.tn
                     mode:kUPPayModeDistrbution
           viewController:viewController
                 delegate:self];
}

#pragma mark -

- (void)UPPayPluginResult:(NSString *)result
{
    if ( [result isEqualToString:@"success"] )
    {
        //支付成功
        [self notifySucceed];
    }
    else if ( [result isEqualToString:@"fail"] )
    {
        //支付失败
        [self notifyFailed];
    }
    else if( [result isEqualToString:@"cancel"] )
    {
        //取消操作
        if ( self.whenCancel )
        {
            self.whenCancel();
        }
    }
}

#pragma mark -

- (void)notifySucceed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UnionPaySucceedNotification object:nil];
    
    if ( self.whenSucceed )
    {
        self.whenSucceed();
    }
}

- (void)notifyFailed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UnionPayFailedNotification object:nil];
    
    if ( self.whenFailed )
    {
        self.whenFailed();
    }
}

- (void)notifyCanceled
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UnionPayCanceledNotification object:nil];
    
    if ( self.whenCancel )
    {
        self.whenCancel();
    }
}

@end
