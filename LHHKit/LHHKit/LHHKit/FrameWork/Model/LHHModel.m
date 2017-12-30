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


#import "LHHModel.h"

@interface LHHModel ()
@end

@implementation LHHModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)cacheKey
{
    return [[self class] description];
}

- (void)loadCache {}

- (void)saveCache {}

- (void)clearCache {}

@end
