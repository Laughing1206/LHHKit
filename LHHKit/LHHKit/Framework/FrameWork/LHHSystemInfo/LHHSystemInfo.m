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

#import "LHHSystemInfo.h"
#import "SSKeychain.h"

@implementation LHHSystemInfo

+ (BOOL)everLaunched
{
    return [self launchedTimes] > 0;
}

+ (NSInteger)launchedTimes
{
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * launchedTimesKey = [NSString stringWithFormat:@"version-%@-app.launched.times",version];
    
    NSInteger launchedTimes = [[NSUserDefaults standardUserDefaults] integerForKey:launchedTimesKey];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        [[NSUserDefaults standardUserDefaults] setInteger:(launchedTimes + 1)
                                                   forKey:launchedTimesKey];
    });
    
    return launchedTimes;
}

+ (NSString *)appVersion
{
    static NSString * __identifier = nil;
    if ( nil == __identifier )
    {
        __identifier = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] copy];
    }
    return __identifier;
}

+ (NSString *)appIdentifier
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    static NSString * __identifier = nil;
    if ( nil == __identifier )
    {
        __identifier = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] copy];
    }
    return __identifier;
#else    // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return @"";
#endif    // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)deviceUUID
{
    static NSString * __udid = nil;
    if ( nil == __udid )
    {
        NSString * udid = [SSKeychain passwordForService:[self appIdentifier] account:@"udid"];
        if (!udid) {
            udid = [[UIDevice currentDevice].identifierForVendor UUIDString];
            [SSKeychain setPassword:udid forService:[self appIdentifier] account:@"udid"];
        }
        __udid = udid;
    }
    return __udid;
}

+ (NSString *)getPreferredLanguage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    return preferredLang;
}

+ (NSString *)bundleVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
#else
    return nil;
#endif
}

+ (NSString *)bundleShortVersion
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
#else
    return nil;
#endif
}

+ (NSString *)bundleIdentifier
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
#else
    return nil;
#endif
}

+ (NSString *)urlScheme
{
    return [self urlSchemeWithName:nil];
}

+ (NSString *)urlSchemeWithName:(NSString *)name
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for ( NSDictionary * dict in array )
    {
        if ( name )
        {
            NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
            if ( nil == URLName )
            {
                continue;
            }
            
            if ( NO == [URLName isEqualToString:name] )
            {
                continue;
            }
        }
        
        NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        if ( nil == URLSchemes || 0 == URLSchemes.count )
        {
            continue;
        }
        
        NSString * scheme = [URLSchemes objectAtIndex:0];
        if ( scheme && scheme.length )
        {
            return scheme;
        }
    }
    
    return nil;
    
#else
    
    return nil;
    
#endif
}

@end
