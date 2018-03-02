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



#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)

+ (NSTimer *)scheduledWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void(^)(void))block
{
    return [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(ql_blockInvoke:) userInfo:[block copy] repeats:yesOrNo];
}

+ (void)ql_blockInvoke:(NSTimer *)sender
{
    void (^block)(void) = sender.userInfo;
    if (block) {
        block();
    }
}

- (void)pauseTimer
{
    if (!self.isValid) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

- (void)resumeTimer
{
    [self resumeTimerAfterTimeInterval:0];
}

@end
