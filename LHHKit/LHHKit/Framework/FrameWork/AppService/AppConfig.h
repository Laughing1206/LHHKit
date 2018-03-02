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


FOUNDATION_EXPORT NSString * const DefaultAppServerAPIURL;


#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"

@interface AppConfig : NSObject

SingletonInterface(AppConfig)

@property (nonatomic, strong) NSString * kAppServerAPIURL;
@property (nonatomic, strong) NSString * kAppServerDomainName;
@property (nonatomic, strong) NSString * scheme;
@property (nonatomic, strong) AFNetworkReachabilityManager * networkRechabilityManager;
@property (nonatomic, assign) AFNetworkReachabilityStatus currentNetWorkStatus;

+ (void)setupConfigService:(void (^)(id data))block;

+ (NSString *)schemeWithAction:(NSString *)action;

+ (NSString *)cachePathWithType:(NSString *)type;

+ (NSString *)themeCachePath;
@end
