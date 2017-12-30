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
#import "ServiceAlipayConfig.h"

/**
 在Header Search paths添加 $(SRCROOT)/LHHKit/LHHKit/Libs/Payment/Alipay/Vendor
 */
#pragma mark -

FOUNDATION_EXPORT NSString * const AlipaySucceedNotification;
FOUNDATION_EXPORT NSString * const AlipayFailedNotification;
FOUNDATION_EXPORT NSString * const AlipayCanceledNotification;
FOUNDATION_EXPORT NSString * const AlipayProcessingNotification;

#pragma mark -

@interface ServiceAlipay : ServicePay

SingletonInterface(ServiceAlipay)

@property (nonatomic, readonly) ServiceAlipayConfig * config;

@end
