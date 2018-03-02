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

#import "AppDelegateProxy.h"
#import <objc/runtime.h>

@interface AppDelegateProxy ()
@end

@implementation AppDelegateProxy

- (instancetype)initWithProxy:(id)proxy;
{
    if (self)
    {
        _proxy = proxy;
    }
    return self;
}

- (NSInvocation *)_copyInvocation:(NSInvocation *)invocation
{
    NSInvocation *copy = [NSInvocation invocationWithMethodSignature:[invocation methodSignature]];
    NSUInteger argCount = [[invocation methodSignature] numberOfArguments];
    
    for (int i = 0; i < argCount; i++)
    {
        char buffer[sizeof(intmax_t)];
        [invocation getArgument:(void *)&buffer atIndex:i];
        [copy setArgument:(void *)&buffer atIndex:i];
    }
    
    return copy;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self.origin respondsToSelector:invocation.selector])
    {
        [invocation invokeWithTarget:self.origin];
    }
    
    if ([self.proxy respondsToSelector:invocation.selector])
    {
        NSInvocation *invocationCopy = [self _copyInvocation:invocation];
        [invocationCopy invokeWithTarget:self.proxy];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    id result = [self.origin methodSignatureForSelector:sel];
    if (!result) {
        result = [self.proxy methodSignatureForSelector:sel];
    }
    
    return result;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return ([self.origin respondsToSelector:aSelector]
            || [self.proxy respondsToSelector:aSelector]);
}
@end
