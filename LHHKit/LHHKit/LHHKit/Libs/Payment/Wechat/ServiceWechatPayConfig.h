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

@interface ServiceWechatPayConfig : NSObject

SingletonInterface(ServiceWechatPayConfig)

@property (nonatomic, retain) NSString *	appId;

@property (nonatomic, retain) NSString *	appSecret; // 微信开放平台和商户约定的密钥
@property (nonatomic, retain) NSString *	partnerKey; // 微信开放平台和商户约定的支付密钥
@property (nonatomic, retain) NSString *	partnerId;
@property (nonatomic, retain) NSString *	prepayId;
@property (nonatomic, retain) NSString *	package;
@property (nonatomic, retain) NSString *	nonceStr;
@property (nonatomic, retain) NSString *    timestamp;
@property (nonatomic, retain) NSString *    traceId;
@property (nonatomic, retain) NSString *    sign;

@end
