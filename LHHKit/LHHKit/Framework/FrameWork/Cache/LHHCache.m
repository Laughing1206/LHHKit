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



#import "LHHCache.h"
#import "PINCache.h"

@interface LHHCache ()
SingletonInterface(LHHCache)
@property (nonatomic, strong) PINCache * cache;
@end

@implementation LHHCache

SingletonImplemention(LHHCache)

+ (NSString *)cacheName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (instancetype)global
{
    static dispatch_once_t once;
    static __strong LHHCache * global = nil;
    dispatch_once( &once, ^{
        global = [[LHHCache alloc] init];
        global.cache = [[PINCache alloc] initWithName:[self cacheName]];
    } );
    return global;
}

- (void)switchCacheWithName:(NSString *)name
{
    if ( !name ) {
        name = @"default";
    }
    
    self.cache = [[PINCache alloc] initWithName:name];
}

#pragma mark -

- (void)setObject:(id <NSCoding, NSObject>)object forKey:(NSString *)key
{
    if ( !object )
    {
        return;
    }
    
    NSParameterAssert( [object respondsToSelector:@selector(initWithCoder:)] && [object respondsToSelector:@selector(encodeWithCoder:)] );
    
    [self.cache.diskCache setObject:(id<NSCoding>)object forKey:key];
}

- (id <NSCoding>)objectForKey:(NSString *)key
{
    return [self.cache.diskCache objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    [self.cache.diskCache removeObjectForKey:key];
}

#pragma mark -

+ (void)switchCacheWithName:(NSString *)name
{
    [[self sharedLHHCache] switchCacheWithName:name];
}

+ (void)setObject:(id)object forKey:(NSString *)key
{
    [[self sharedLHHCache] setObject:object forKey:key];
}

+ (id)objectForKey:(NSString *)key
{
    return [[self sharedLHHCache] objectForKey:key];
}

+ (void)removeObjectForKey:(NSString *)key
{
    return [[self sharedLHHCache] removeObjectForKey:key];
}

@end
