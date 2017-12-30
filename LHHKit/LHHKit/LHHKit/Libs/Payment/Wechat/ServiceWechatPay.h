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

#import "ServicePay.h"
#import "ServiceWechatPayConfig.h"
#import "WXApi.h"

#pragma mark -

FOUNDATION_EXPORT NSString * const WXChatPaySucceedNotification;
FOUNDATION_EXPORT NSString * const WXChatPayFailedNotification;
FOUNDATION_EXPORT NSString * const WXChatPayCanceledNotification;

#pragma mark -

@interface ServiceWechatPay : ServicePay<WXApiDelegate>

SingletonInterface(ServiceWechatPay)

@property (nonatomic, readonly) ServiceWechatPayConfig * config;

@end
