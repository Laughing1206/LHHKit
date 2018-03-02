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

#import "AppService.h"
#import "AppDelegateProxy.h"
#import <objc/runtime.h>

@class AppDelegateProxy;

@interface AppService ()
@property (nonatomic, strong) AppDelegateProxy * proxy;
@property (nonatomic, strong) NSMutableArray * services;
@end

@implementation AppService

SingletonImplemention(AppService)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _proxy = [[AppDelegateProxy alloc] initWithProxy:self];
        _services = [NSMutableArray array];
    }
    return self;
}

+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return [[self sharedAppService] application:application didFinishLaunchingWithOptions:launchOptions];
}

+ (void)addService:(id)service
{
    [[self sharedAppService] addService:service];
}

+ (void)removeService:(id)service
{
    [[self sharedAppService] removeService:service];
}

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.proxy.origin = application.delegate;
    application.delegate = (id<UIApplicationDelegate>)self.proxy;
    
    [self.services enumerateObjectsUsingBlock:^(id<AppService> obj, NSUInteger idx, BOOL *stop) {
        if ( [obj respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)] )
        {
            [obj application:application didFinishLaunchingWithOptions:launchOptions];
        }
    }];
    
    return YES;
}

- (void)addService:(id)service
{
    [_services addObject:service];
}

- (void)removeService:(id)service
{
    [_services removeObject:service];
}

#pragma mark - Dispatch messages

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
    [self.services enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:invocation.selector])
        {
            NSInvocation *invocationCopy = [self _copyInvocation:invocation];
            [invocationCopy invokeWithTarget:obj];
        }
    }];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    __block id result = nil;
    
    [self.services enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = [obj methodSignatureForSelector:sel];
        *stop = result != nil;
    }];
    
    return result;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    __block BOOL couldRespond = NO;
    
    if ( [[self class] shouldHandleSelector:aSelector] )
    {
        [self.services enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            couldRespond = [obj respondsToSelector:aSelector];
            *stop = couldRespond;
        }];
    }
    
    return couldRespond;
}

#pragma mark -

+ (BOOL)shouldHandleSelector:(SEL)selector
{
    static NSMutableArray * selectors;
    if ( !selectors )
    {
        selectors = [NSMutableArray array];
        [selectors addObjectsFromArray:[NSObject selectorNamesOfProtocol:@"UIApplicationDelegate"]];
    }
    return [selectors containsObject:NSStringFromSelector(selector)];
}

@end

#pragma mark -

#ifndef APPDELEGATE_HAS_BEEN_DEFINED

@interface AppDelegateProxy : NSProxy

@property (nonatomic, readonly, weak) id proxy;     // proxy is the middle man
@property (nonatomic, strong) id origin; // the origin delegate

- (instancetype)initWithProxy:(id)proxy;

@end

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

#endif // #ifndef APPDELEGATE_HAS_BEEN_DEFINED@end
