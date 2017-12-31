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


NSString * const DefaultAppServerAPIURL = @"http://api.renrengyw.com";

#import "AppConfig.h"

@implementation AppConfig

@synthesize kAppServerAPIURL = _kAppServerAPIURL;
@synthesize kAppServerDomainName = _kAppServerDomainName;

SingletonImplemention(AppConfig)

- (AFNetworkReachabilityManager *)networkRechabilityManager
{
    if (_networkRechabilityManager == nil)
    {
        _networkRechabilityManager = [AFNetworkReachabilityManager sharedManager];
    }
     
    return _networkRechabilityManager;
}

- (void)setKAppServerAPIURL:(NSString *)kAppServerAPIURL
{
    _kAppServerAPIURL = kAppServerAPIURL;
    
    // 切换域名
    self.kAppServerDomainName = [[[[kAppServerAPIURL
                                    componentsSeparatedByString:@"//"] lastObject]
                                  componentsSeparatedByString:@"/"] firstObject];
}

- (NSString *)kAppServerAPIURL
{
    if ( !(_kAppServerAPIURL && _kAppServerAPIURL.length) )
    {
        _kAppServerAPIURL = DefaultAppServerAPIURL;
    }

    return _kAppServerAPIURL;
}

- (NSString *)kAppServerDomainName
{
    if ( !(_kAppServerDomainName && _kAppServerDomainName.length) )
    {
        _kAppServerDomainName = [[[[DefaultAppServerAPIURL componentsSeparatedByString:@"//"] lastObject] componentsSeparatedByString:@"/"] firstObject];
    }

    return _kAppServerDomainName;
}

- (NSString *)scheme
{
    return @"LHHKit";
}

+ (NSString *)schemeWithAction:(NSString *)action
{
    return [[AppConfig sharedAppConfig].scheme stringByAppendingString:action];
}

#pragma mark -

+ (NSString *)cachePathWithType:(NSString *)type
{
    if ( [type isEqualToString:@"themes"] )
    {
        return [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[AppConfig sharedAppConfig].kAppServerDomainName] stringByAppendingString:@"/themes"];
    }
    else if ( [type isEqualToString:@"splash"] )
    {
        return [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[AppConfig sharedAppConfig].kAppServerDomainName] stringByAppendingString:@"/splash"];
    }
    else
    {
        return [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[AppConfig sharedAppConfig].kAppServerDomainName] stringByAppendingString:@"/Caches"];
    }
}

+ (NSString *)themeCachePath
{
    return [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[AppConfig sharedAppConfig].kAppServerDomainName] stringByAppendingString:@"/themes"];
}

+ (void)setupConfigService:(void (^)(id data))block
{
    //初始化数据

}

#pragma mark - 开启网络监控
- (void)openNetWorkMonitoring
{
    [self.networkRechabilityManager startMonitoring];
    
    @weakify(self);
    [self.networkRechabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                [[NSNotificationCenter defaultCenter]postNotificationName:ReachabilityStatusUnknownNotifity object:nil];
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                
                [[NSNotificationCenter defaultCenter]postNotificationName:ReachabilityStatusNotReachableNotifity object:nil];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                [[NSNotificationCenter defaultCenter]postNotificationName:ReachabilityStatusReachableViaWWANNotifity object:nil];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                [[NSNotificationCenter defaultCenter]postNotificationName:ReachabilityStatusReachableViaWiFiNotifity object:nil];
                break;
        }
        self.currentNetWorkStatus = self.networkRechabilityManager.networkReachabilityStatus;
    }];
}

@end
