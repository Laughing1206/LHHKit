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

#import "NSObject+PINCache.h"
#import "PINCache.h"

@implementation NSObject (PINCache)

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key
{
    [[PINCache sharedCache].diskCache setObject:object forKey:key];
}

- (id <NSCoding>)objectForKey:(NSString *)key
{
    return [[PINCache sharedCache].diskCache objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    [[PINCache sharedCache] removeObjectForKey:key];
}

@end
