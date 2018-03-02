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

@interface ServiceAlipayConfig : NSObject

SingletonInterface(ServiceAlipayConfig)

@property (nonatomic, strong) NSString * partner;
@property (nonatomic, strong) NSString * seller;
@property (nonatomic, strong) NSString * privateKey;
@property (nonatomic, strong) NSString * publicKey;
@property (nonatomic, strong) NSString * notifyURL;
@property (nonatomic, strong) NSString * tradeNO;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * productDescription;
@property (nonatomic, strong) NSString * amount;

@property (nonatomic, strong) NSString * order_string;;
//@property (nonatomic, strong) NSString * payment_id; // 可选参数：多店时使用，后台区分店铺

@end
