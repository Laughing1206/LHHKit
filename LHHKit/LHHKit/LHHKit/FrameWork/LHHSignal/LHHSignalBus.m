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

#import "LHHSignalBus.h"
#import "LHHAssert.h"
#import "SignalHandler.h"
@implementation LHHSignalBus
{
    NSMutableDictionary * _handlers;
}

SingletonImplemention(LHHSignalBus)

- (id)init
{
    self = [super init];
    if ( self )
    {
        _handlers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_handlers removeAllObjects];
    _handlers = nil;
}

- (BOOL)send:(LHHSignal *)signal
{
    if ( signal.dead )
    {
//        NSLog( @"signal '%@', already dead", signal.prettyName );
        return NO;
    }
    // Routes signal
    
    if ( signal.target )
    {
        signal.sending = YES;
        
        [self routes:signal];
    }
    else
    {
        signal.arrived = YES;
    }
    
//    NSString * newline = @"\n   > ";
    
//    NSLog(@"%@", newline);
    
    if ( signal.arrived )
    {
        if ( signal.jumpPath )
        {
//            NSLog( @"Signal '%@'%@%@%@[Done]", signal.prettyName, newline, [signal.jumpPath join:newline], newline );
        }
        else
        {
//            NSLog( @"Signal '%@'%@[Done]", signal.prettyName, newline );
        }
    }
    else if ( signal.dead )
    {
        if ( signal.jumpPath )
        {
//            NSLog( @"Signal '%@'%@%@%@[Dead]", signal.prettyName, newline, [signal.jumpPath join:newline], newline );
        }
        else
        {
//            NSLog( @"Signal '%@'%@[Dead]", signal.prettyName, newline );
        }
    }
    
    return signal.arrived;
}

- (BOOL)forward:(LHHSignal *)signal
{
    return [self forward:signal to:nil];
}

- (BOOL)forward:(LHHSignal *)signal to:(id)target
{
    if ( signal.dead )
    {
//        NSLog( @"signal '%@', already dead", signal.prettyName );
        return NO;
    }
    
    if ( nil == signal.target )
    {
//        NSLog( @"signal '%@', no target", signal.prettyName );
        return NO;
    }
    
    [signal log:signal.target];
    
    if ( nil == target )
    {
        signal.arrived = YES;
        return YES;
    }
    
    // Routes signal
    
    signal.target = target;
    signal.sending = YES;
    
    [self routes:signal];
    
    return signal.arrived;
}

- (void)routes:(LHHSignal *)signal
{
    NSMutableArray * classes = [NSMutableArray nonRetainingArray];
    
    for ( Class clazz = [signal.target class]; nil != clazz; clazz = class_getSuperclass(clazz) )
    {
        [classes addObject:clazz];
    }
    
    [self routes:signal to:signal.target forClasses:classes];
    
    if ( NO == signal.arrived )
    {
        NSObject *        object = [signal.target signalResponders];
        EncodingType    objectType = [Kit_Encoding typeOfObject:object];
        
        if ( nil == object )
        {
            signal.arrived = YES;
        }
        else
        {
            if ( EncodingType_Array == objectType )
            {
                NSArray * responders = (NSArray *)object;
                
                if ( 1 == responders.count )
                {
                    if ( NO == signal.dead )
                    {
                        [signal log:signal.target];
                        
                        signal.target = [responders objectAtIndex:0];
                        signal.sending = YES;
                        
                        [self routes:signal];
                    }
                }
                else
                {
                    for ( NSObject * responder in responders )
                    {
                        LHHSignal * clonedSignal = [signal clone];
                        
                        if ( clonedSignal )
                        {
                            if ( NO == clonedSignal.dead )
                            {
                                [clonedSignal log:clonedSignal.target];
                                
                                clonedSignal.target = responder;
                                clonedSignal.sending = YES;
                                
                                [self routes:clonedSignal];
                            }
                            
                        }
                    }
                }
            }
            else
            {
                if ( NO == signal.dead )
                {
                    [signal log:signal.target];
                    
                    signal.target = object;
                    signal.sending = YES;
                    
                    [self routes:signal];
                }
                
            }
        }
    }
}

- (void)routes:(LHHSignal *)signal to:(NSObject *)target forClasses:(NSArray *)classes
{
    if ( 0 == classes.count )
    {
        return;
    }
    
    if ( nil == signal.source || nil == signal.target )
    {
//        NSLog( @"No signal source/target" );
        return;
    }
    
    NSObject *    prioAlias = nil;
    NSString *    prioSelector = nil;
    NSString *    nameSpace = nil;
    NSString *    tagString = nil;
    
    NSString *    signalPrefix = nil;
    NSString *    signalClass = nil;
    NSString *    signalMethod = nil;
    NSString *    signalMethod2 = nil;
    
    if ( signal.name && [signal.name hasPrefix:@"signal."] )
    {
        NSArray * array = [signal.name componentsSeparatedByString:@"."];
        if ( array && array.count > 1 )
        {
            signalPrefix = (NSString *)[array safeObjectAtIndex:0];
            signalClass = (NSString *)[array safeObjectAtIndex:1];
            signalMethod = (NSString *)[array safeObjectAtIndex:2];
            signalMethod2 = (NSString *)[array safeObjectAtIndex:3];
            
            ASSERT( [signalPrefix isEqualToString:@"signal"] );
        }
    }
    
    if ( signal.source )
    {
        nameSpace = [signal.source signalNamespace];
        if ( nameSpace && nameSpace.length )
        {
            nameSpace = [nameSpace stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            nameSpace = [nameSpace stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        }
        
        tagString = [signal.source signalTag];
        if ( tagString && tagString.length )
        {
            tagString = [tagString stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            tagString = [tagString stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        }
        
        if ( nameSpace && tagString )
        {
            prioSelector = [NSString stringWithFormat:@"%@_%@", nameSpace, tagString];
        }
        
        prioAlias = [signal.source signalAlias];
    }
    
    for ( Class targetClass in classes )
    {
        NSString *    cacheName = nil;
        NSString *    cachedSelectorName = nil;
        SEL            cachedSelector = nil;
        
        if ( prioSelector )
        {
            cacheName = [NSString stringWithFormat:@"%@/%@/%@", signal.name, [targetClass description], prioSelector];
        }
        else
        {
            cacheName = [NSString stringWithFormat:@"%@/%@", signal.name, [targetClass description]];
        }
        
        cachedSelectorName = [_handlers objectForKey:cacheName];
        
        if ( cachedSelectorName )
        {
            cachedSelector = NSSelectorFromString( cachedSelectorName );
            
            if ( cachedSelector )
            {
                BOOL hit = [self signal:signal perform:cachedSelector class:targetClass target:target];
                if ( hit )
                {
                    break;
                }
            }
        }
        
        {
            NSString *    selectorName = nil;
            SEL            selector = nil;
            BOOL        performed = NO;
            
            // native selector
            
            if ( [signal.name hasPrefix:@"signal."] )
            {
                if ( NO == performed )
                {
                    selectorName = [signal.name substringFromIndex:@"signal.".length];
                    selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
                    selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
                    selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
                    
                    selector = NSSelectorFromString( selectorName );
                    
                    performed = [self signal:signal perform:selector class:targetClass target:target];
                    if ( performed )
                    {
                        [_handlers setObject:selectorName forKey:cacheName];
                        break;
                    }
                }
            }
            
            if ( [signal.name hasPrefix:@"selector."] )
            {
                if ( NO == performed )
                {
                    selectorName = [signal.name substringFromIndex:@"selector.".length];
                    
                    selector = NSSelectorFromString( selectorName );
                    
                    performed = [self signal:signal perform:selector class:targetClass target:target];
                    if ( performed )
                    {
                        [_handlers setObject:selectorName forKey:cacheName];
                        break;
                    }
                }
            }
            
            if ( NO == performed )
            {
                if ( [signal.name hasSuffix:@":"] )
                {
                    selectorName = signal.name;
                }
                else
                {
                    selectorName = [NSString stringWithFormat:@"%@:", signal.name];
                }
                
                selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
                selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
                selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
                
                selector = NSSelectorFromString( selectorName );
                
                performed = [self signal:signal perform:selector class:targetClass target:target];
                if ( performed )
                {
                    [_handlers setObject:selectorName forKey:cacheName];
                    break;
                }
            }
            
            // high priority selector
            
            if ( prioAlias )
            {
                if ( [prioAlias isKindOfClass:[NSArray class]] )
                {
                    for ( NSString * alias in (NSArray *)prioAlias )
                    {
                        selectorName = [NSString stringWithFormat:@"handleSignal____%@:", alias];
                        selector = NSSelectorFromString( selectorName );
                        
                        performed = [self signal:signal perform:selector class:targetClass target:target];
                        if ( performed )
                        {
                            [_handlers setObject:selectorName forKey:cacheName];
                            break;
                        }
                        
                        if ( signalMethod && signalMethod2 )
                        {
                            selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", alias, signalMethod, signalMethod2];
                            selector = NSSelectorFromString( selectorName );
                            
                            performed = [self signal:signal perform:selector class:targetClass target:target];
                            if ( performed )
                            {
                                [_handlers setObject:selectorName forKey:cacheName];
                                break;
                            }
                        }
                        
                        if ( signalMethod )
                        {
                            selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", alias, signalMethod];
                            selector = NSSelectorFromString( selectorName );
                            
                            performed = [self signal:signal perform:selector class:targetClass target:target];
                            if ( performed )
                            {
                                [_handlers setObject:selectorName forKey:cacheName];
                                break;
                            }
                        }
                    }
                }
                else
                {
                    selectorName = [NSString stringWithFormat:@"handleSignal____%@:", prioAlias];
                    selector = NSSelectorFromString( selectorName );
                    
                    performed = [self signal:signal perform:selector class:targetClass target:target];
                    if ( performed )
                    {
                        [_handlers setObject:selectorName forKey:cacheName];
                        break;
                    }
                    
                    if ( signalMethod && signalMethod2 )
                    {
                        selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", prioAlias, signalMethod, signalMethod2];
                        selector = NSSelectorFromString( selectorName );
                        
                        performed = [self signal:signal perform:selector class:targetClass target:target];
                        if ( performed )
                        {
                            [_handlers setObject:selectorName forKey:cacheName];
                            break;
                        }
                    }
                    
                    if ( signalMethod )
                    {
                        selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", prioAlias, signalMethod];
                        selector = NSSelectorFromString( selectorName );
                        
                        performed = [self signal:signal perform:selector class:targetClass target:target];
                        if ( performed )
                        {
                            [_handlers setObject:selectorName forKey:cacheName];
                            break;
                        }
                    }
                }
            }
            
            if ( performed )
            {
                break;
            }
            
            // signal selector
            
            if ( prioSelector )
            {
                // eg. handleSignal( Class, tag )
                
                selectorName = [NSString stringWithFormat:@"handleSignal____%@:", prioSelector];
                selector = NSSelectorFromString( selectorName );
                
                performed = [self signal:signal perform:selector class:targetClass target:target];
                if ( performed )
                {
                    [_handlers setObject:selectorName forKey:cacheName];
                    break;
                }
            }
            
            // eg. handleSignal( Class, Signal, State )
            
            if ( signalClass && signalMethod && signalMethod2 )
            {
                selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", signalClass, signalMethod, signalMethod2];
                selector = NSSelectorFromString( selectorName );
                
                performed = [self signal:signal perform:selector class:targetClass target:target];
                if ( performed )
                {
                    [_handlers setObject:selectorName forKey:cacheName];
                    break;
                }
            }
            
            // eg. handleSignal( Class, Signal )
            
            if ( signalClass && signalMethod )
            {
                selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", signalClass, signalMethod];
                selector = NSSelectorFromString( selectorName );
                
                performed = [self signal:signal perform:selector class:targetClass target:target];
                if ( performed )
                {
                    [_handlers setObject:selectorName forKey:cacheName];
                    break;
                }
            }
            
            // eg. handleSignal( Class )
            
            if ( signalClass )
            {
                selectorName = [NSString stringWithFormat:@"handleSignal____%@:", signalClass];
                selector = NSSelectorFromString( selectorName );
                
                performed = [self signal:signal perform:selector class:targetClass target:target];
                if ( performed )
                {
                    [_handlers setObject:selectorName forKey:cacheName];
                    break;
                }
            }
            
            // eg. handleSignal( Class, Signal )
            
            if ( [signal.name hasPrefix:@"signal____"] )
            {
                selectorName = [signal.name stringByReplacingOccurrencesOfString:@"signal____" withString:@"handleSignal____"];
            }
            else
            {
                selectorName = [NSString stringWithFormat:@"handleSignal____%@:", signal.name];
            }
            
            selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
            selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            
            if ( NO == [selectorName hasSuffix:@":"] )
            {
                selectorName = [selectorName stringByAppendingString:@":"];
            }
            
            selector = NSSelectorFromString( selectorName );
            
            performed = [self signal:signal perform:selector class:targetClass target:target];
            if ( performed )
            {
                [_handlers setObject:selectorName forKey:cacheName];
                break;
            }
            
            for ( Class rtti = [signal.source class]; nil != rtti && rtti != [NSObject class]; rtti = class_getSuperclass(rtti) )
            {
                // eg. handleSignal( Class, Signal, State )
                
                if ( (signalMethod && signalMethod.length) && signalMethod2 && signalMethod2.length )
                {
                    selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@____%@:", [rtti description], signalMethod, signalMethod2];
                    selector = NSSelectorFromString( selectorName );
                    
                    performed = [self signal:signal perform:selector class:targetClass target:target];
                    if ( performed )
                    {
                        [_handlers setObject:selectorName forKey:cacheName];
                        break;
                    }
                }
                
                // eg. handleSignal( Class, Signal )
                
                if ( signalMethod && signalMethod.length )
                {
                    selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", [rtti description], signalMethod];
                    selector = NSSelectorFromString( selectorName );
                    
                    performed = [self signal:signal perform:selector class:targetClass target:target];
                    if ( performed )
                    {
                        [_handlers setObject:selectorName forKey:cacheName];
                        break;
                    }
                }
                
                // eg. handleSignal( Class, tag )
                
                if ( tagString && tagString.length )
                {
                    selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", [rtti description], tagString];
                    selector = NSSelectorFromString( selectorName );
                    
                    performed = [self signal:signal perform:selector class:targetClass target:target];
                    if ( performed )
                    {
                        [_handlers setObject:selectorName forKey:cacheName];
                        break;
                    }
                    
                    selectorName = [NSString stringWithFormat:@"handleSignal____%@:", tagString];
                    selector = NSSelectorFromString( selectorName );
                    
                    performed = [self signal:signal perform:selector class:targetClass target:target];
                    if ( performed )
                    {
                        [_handlers setObject:selectorName forKey:cacheName];
                        break;
                    }
                }
                
                // eg. handleSignal( Class )
                
                selectorName = [NSString stringWithFormat:@"handleSignal____%@:", [rtti description]];
                selector = NSSelectorFromString( selectorName );
                
                performed = [self signal:signal perform:selector class:targetClass target:target];
                if ( performed )
                {
                    [_handlers setObject:selectorName forKey:cacheName];
                    break;
                }
            }
            
            if ( NO == performed )
            {
                selectorName = @"handleSignal____:";
                selector = NSSelectorFromString( selectorName );
                
                performed = [self signal:signal perform:selector class:targetClass target:target];
                if ( performed )
                {
                    [_handlers setObject:selectorName forKey:cacheName];
                    break;
                }
            }
            
            if ( NO == performed )
            {
                selectorName = @"handleSignal:";
                selector = NSSelectorFromString( selectorName );
                
                performed = [self signal:signal perform:selector class:targetClass target:target];
                if ( performed )
                {
                    [_handlers setObject:selectorName forKey:cacheName];
                    break;
                }
            }
        }
    }
}

- (BOOL)signal:(LHHSignal *)signal perform:(SEL)sel class:(Class)clazz target:(id)target
{
    ASSERT( nil != signal );
    ASSERT( nil != target );
    ASSERT( nil != sel );
    ASSERT( nil != clazz );
    
    BOOL performed = NO;
    
    // try block
    
    if ( NO == performed )
    {
        SignalHandler * handler = [target blockHandler];
        if ( handler )
        {
            BOOL found = [handler trigger:[NSString stringWithUTF8String:sel_getName(sel)] withObject:signal];
            if ( found )
            {
                signal.hit = YES;
                signal.hitCount += 1;
                
                performed = YES;
            }
        }
    }
    
    // try selector
    
    if ( NO == performed )
    {
        Method method = class_getInstanceMethod( clazz, sel );
        if ( method )
        {
            ImpFuncType imp = (ImpFuncType)method_getImplementation( method );
            if ( imp )
            {
                imp( target, sel, (__bridge void *)signal );
                
                signal.hit = YES;
                signal.hitCount += 1;
                
                performed = YES;
            }
        }
    }
    
    return performed;
}

@end

