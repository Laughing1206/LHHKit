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

#import <Foundation/Foundation.h>
#import "ServicePay.h"
#import "ServiceUnionPayConfig.h"
#import "UPPayPlugin.h"

#pragma mark -

FOUNDATION_EXPORT NSString * const UnionPaySucceedNotification;
FOUNDATION_EXPORT NSString * const UnionPayFailedNotification;
FOUNDATION_EXPORT NSString * const UnionPayCanceledNotification;

#pragma mark -

@interface ServiceUnionPay : ServicePay<UPPayPluginDelegate>

SingletonInterface(ServiceUnionPay)

@property (nonatomic, readonly) ServiceUnionPayConfig * config;

- (void)payInViewController:(UIViewController *)viewController;

@end
