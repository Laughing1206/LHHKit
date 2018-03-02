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

#import "SignalHandler.h"

#pragma mark -

typedef void (^ __handlerBlockType )( id object );

#pragma mark -

@implementation NSObject(BlockHandler)

- (SignalHandler *)blockHandlerOrCreate
{
    SignalHandler * handler = [self getAssociatedObjectForKey:"blockHandler"];
    
    if ( nil == handler )
    {
        handler = [[SignalHandler alloc] init];
        
        [self retainAssociatedObject:handler forKey:"blockHandler"];
    }
    
    return handler;
}

- (SignalHandler *)blockHandler
{
    return [self getAssociatedObjectForKey:"blockHandler"];
}

- (void)addBlock:(id)block forName:(NSString *)name
{
    SignalHandler * handler = [self blockHandlerOrCreate];
    
    if ( handler )
    {
        [handler addHandler:block forName:name];
    }
}

- (void)removeBlockForName:(NSString *)name
{
    SignalHandler * handler = [self blockHandler];
    
    if ( handler )
    {
        [handler removeHandlerForName:name];
    }
}

- (void)removeAllBlocks
{
    SignalHandler * handler = [self blockHandler];
    
    if ( handler )
    {
        [handler removeAllHandlers];
    }
    
    [self removeAssociatedObjectForKey:"blockHandler"];
}

@end

#pragma mark -

@implementation SignalHandler
{
    NSMutableDictionary * _blocks;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        _blocks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_blocks removeAllObjects];
    _blocks = nil;
}

- (BOOL)trigger:(NSString *)name
{
    return [self trigger:name withObject:nil];
}

- (BOOL)trigger:(NSString *)name withObject:(id)object
{
    if ( nil == name )
        return NO;
    
    __handlerBlockType block = (__handlerBlockType)[_blocks objectForKey:name];
    if ( nil == block )
        return NO;
    
    block( object );
    return YES;
}

- (void)addHandler:(id)handler forName:(NSString *)name
{
    if ( nil == name )
        return;
    
    if ( nil == handler )
    {
        [_blocks removeObjectForKey:name];
    }
    else
    {
        [_blocks setObject:handler forKey:name];
    }
}

- (void)removeHandlerForName:(NSString *)name
{
    if ( nil == name )
        return;
    
    [_blocks removeObjectForKey:name];
}

- (void)removeAllHandlers
{
    [_blocks removeAllObjects];
}

@end

