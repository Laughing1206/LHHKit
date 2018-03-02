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



#import "SplashModel.h"

@implementation SplashModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.img forKey:@"img"];
    [aCoder encodeObject:self.lastTime forKey:@"lastTime"];
    [aCoder encodeObject:self.image forKey:@"image"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.img = [aDecoder decodeObjectForKey:@"img"];
        self.lastTime = [aDecoder decodeObjectForKey:@"lastTime"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
    }
    return self;
}
@end
