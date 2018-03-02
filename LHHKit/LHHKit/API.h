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

@interface RESULT : NSObject
@property (nonatomic, strong) NSArray * industry; // 闪屏列表
@property (nonatomic, strong) NSArray * merchant_type; // 闪屏列表
@property (nonatomic, strong) NSArray * merchant_banks; // 闪屏列表
@property (nonatomic, strong) NSArray * merchant_label; // 闪屏列表
@end

@interface V2_ECAPI_SPLASH_LIST_REQUEST : HTTPRequest
@property (nonatomic, strong) NSString * returnMsg; // 闪屏列表
@end

@interface V2_ECAPI_SPLASH_LIST_RESPONSE : NSObject<HTTPResponse>
@property (nonatomic, strong) RESULT * result; // 闪屏列表
@property (nonatomic, strong) NSString * returnMsg; // 闪屏列表
@property (nonatomic, strong) NSString * returnCode; // 闪屏列表
@end

@interface V2_ECAPI_SPLASH_LIST_API : HTTPApi
@property (nonatomic, strong) V2_ECAPI_SPLASH_LIST_REQUEST * req;
@property (nonatomic, strong) V2_ECAPI_SPLASH_LIST_RESPONSE * resp;
@end


