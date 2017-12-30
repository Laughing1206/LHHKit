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

#import "LHHSignal.h"
#import "SignalHandler.h"
#import "LHHSignalBus.h"

#pragma mark -

@implementation NSObject(SignalResponder)

@def_prop_dynamic( LHHEventBlock,    onSignal );
@def_prop_dynamic( NSMutableArray *,    userResponders );

#pragma mark -

- (LHHSignalBlock)onSignal
{
    @weakify( self );
    
    LHHSignalBlock block = ^ NSObject * ( NSString * name, id signalBlock )
    {
        @strongify( self );
        
        name = [name stringByReplacingOccurrencesOfString:@"signal." withString:@"handleSignal____"];
        name = [name stringByReplacingOccurrencesOfString:@"signal____" withString:@"handleSignal____"];
        name = [name stringByReplacingOccurrencesOfString:@"-" withString:@"____"];
        name = [name stringByReplacingOccurrencesOfString:@"." withString:@"____"];
        name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"____"];
        name = [name stringByAppendingString:@":"];
        
        if ( signalBlock )
        {
            [self addBlock:signalBlock forName:name];
        }
        else
        {
            [self removeBlockForName:name];
        }
        
        return self;
    };
    
    return [block copy];
}

#pragma mark -

- (id)signalResponders
{
    return [self userResponders];
}

- (id)signalAlias
{
    return nil;
}

- (NSString *)signalNamespace
{
    return NSStringFromClass([self class]);
}

- (NSString *)signalTag
{
    return nil;
}

- (NSString *)signalDescription
{
    return [NSString stringWithFormat:@"%@", [[self class] description]];
}

#pragma mark -

- (id)userRespondersOrCreate
{
    const char * storeKey = "NSObject.userResponders";
    
    NSMutableArray * responders = [self getAssociatedObjectForKey:storeKey];
    
    if ( nil == responders )
    {
        responders = [NSMutableArray nonRetainingArray];
        
        [self retainAssociatedObject:responders forKey:storeKey];
    }
    return responders;
}

- (NSMutableArray *)userResponders
{
    const char * storeKey = "NSObject.userResponders";
    
    return [self getAssociatedObjectForKey:storeKey];
}

#pragma mark -

- (BOOL)hasSignalResponder:(id)obj
{
    NSMutableArray * responders = [self userResponders];
    
    if ( nil == responders )
    {
        return NO;
    }
    
    for ( id responder in responders )
    {
        if ( responder == obj )
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)addSignalResponder:(id)obj
{
    NSMutableArray * responders = [self userRespondersOrCreate];
    
    if ( responders && NO == [responders containsObject:obj] )
    {
        [responders addObject:obj];
    }
}

- (void)removeSignalResponder:(id)obj
{
    NSMutableArray * responders = [self userResponders];
    
    if ( responders && [responders containsObject:obj] )
    {
        [responders removeObject:obj];
    }
}

- (void)removeAllSignalResponders
{
    NSMutableArray * responders = [self userResponders];
    
    if ( responders )
    {
        [responders removeAllObjects];
    }
}

#pragma mark -

- (void)handleSignal:(LHHSignal *)that
{
    UNUSED( that );
}

@end

#pragma mark -

@implementation NSObject(SignalSender)

- (LHHSignal *)sendSignal:(NSString *)name
{
    return [self sendSignal:name from:self withObject:nil];
}

- (LHHSignal *)sendSignal:(NSString *)name withObject:(NSObject *)object
{
    return [self sendSignal:name from:self withObject:object];
}

- (LHHSignal *)sendSignal:(NSString *)name from:(id)source
{
    return [self sendSignal:name from:source withObject:nil];
}

- (LHHSignal *)sendSignal:(NSString *)name from:(id)source withObject:(NSObject *)object
{
    LHHSignal * signal = [LHHSignal signal];
    
    signal.source = source ? source : self;
    signal.target = self;
    signal.name = name;
    signal.object = object;
    
    [signal send];
    
    return signal;
}

@end

#pragma mark -

@implementation LHHSignal

@def_joint( stateChanged );

@def_prop_unsafe( id,                        source );
@def_prop_unsafe( id,                        target );

@def_prop_copy( BlockType,                    stateChanged );
@def_prop_assign( SignalState,                state );
@def_prop_dynamic( BOOL,                    sending );
@def_prop_dynamic( BOOL,                    arrived );
@def_prop_dynamic( BOOL,                    dead );

@def_prop_assign( BOOL,                        hit );
@def_prop_assign( NSUInteger,                hitCount );
@def_prop_dynamic( NSString *,                prettyName );

@def_prop_strong( NSString *,                name );
@def_prop_strong( id,                        object );
@def_prop_strong( NSMutableDictionary *,    input );
@def_prop_strong( NSMutableDictionary *,    output );

@def_prop_assign( NSTimeInterval,            initTimeStamp );
@def_prop_assign( NSTimeInterval,            sendTimeStamp );
@def_prop_assign( NSTimeInterval,            arriveTimeStamp );

@def_prop_dynamic( NSTimeInterval,            timeElapsed );
@def_prop_dynamic( NSTimeInterval,            timeCostPending );
@def_prop_dynamic( NSTimeInterval,            timeCostExecution );

@def_prop_assign( NSInteger,                jumpCount );
@def_prop_strong( NSArray *,                jumpPath );

BASE_CLASS( LHHSignal )

#pragma mark -

+ (LHHSignal *)signal
{
    return [[LHHSignal alloc] init];
}

+ (LHHSignal *)signal:(NSString *)name
{
    LHHSignal * signal = [[LHHSignal alloc] init];
    signal.name = name;
    return signal;
}

- (id)init
{
    static NSUInteger __seed = 0;
    
    self = [super init];
    if ( self )
    {
        self.name = [NSString stringWithFormat:@"signal-%lu", (unsigned long)__seed++];
        
        _state = SignalState_Inited;
        
        _initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
        _sendTimeStamp = _initTimeStamp;
        _arriveTimeStamp = _initTimeStamp;
    }
    return self;
}

- (void)dealloc
{
    self.jumpPath = nil;
    self.stateChanged = nil;
    
    self.name = nil;
    self.object = nil;
    
    self.input = nil;
    self.output = nil;
}

- (void)deepCopyFrom:(LHHSignal *)right
{
    [super deepCopyFrom:right];
    
    //    self.foreign            = right.foreign;
    self.source                = right.source;
    self.target                = right.target;
    
    self.state                = right.state;
    
    self.name                = [right.name copy];
    //    self.prefix                = [right.prefix copy];
    self.object                = right.object;
    
    self.initTimeStamp        = right.initTimeStamp;
    self.sendTimeStamp        = right.sendTimeStamp;
    self.arriveTimeStamp    = right.arriveTimeStamp;
    
    self.jumpCount            = right.jumpCount;
    self.jumpPath            = [right.jumpPath mutableCopy];
}

- (NSString *)prettyName
{
    return self.name;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[%@] > %@", self.prettyName, [self.jumpPath join:@" > "]];
}

- (BOOL)is:(NSString *)name
{
    return [self.name isEqualToString:name];
}

- (BOOL)isSentFrom:(id)source
{
    return (self.source == source) ? YES : NO;
}

- (SignalState)state
{
    return _state;
}

- (void)setState:(SignalState)newState
{
    [self changeState:newState];
}

- (BOOL)sending
{
    return SignalState_Sending == _state ? YES : NO;
}

- (void)setSending:(BOOL)flag
{
    if ( flag )
    {
        [self changeState:SignalState_Sending];
    }
}

- (BOOL)arrived
{
    return SignalState_Arrived == _state ? YES : NO;
}

- (void)setArrived:(BOOL)flag
{
    if ( flag )
    {
        [self changeState:SignalState_Arrived];
    }
}

- (BOOL)dead
{
    return SignalState_Dead == _state ? YES : NO;
}

- (void)setDead:(BOOL)flag
{
    if ( flag )
    {
        [self changeState:SignalState_Dead];
    }
}

- (BOOL)changeState:(SignalState)newState
{
    if ( newState == _state )
        return NO;
    
    triggerBefore( self, stateChanged );
    
    _state = newState;
    
    if ( SignalState_Sending == _state )
    {
        _sendTimeStamp = [NSDate timeIntervalSinceReferenceDate];
    }
    else if ( SignalState_Arrived == _state )
    {
        _arriveTimeStamp = [NSDate timeIntervalSinceReferenceDate];
    }
    else if ( SignalState_Dead == _state )
    {
        _arriveTimeStamp = [NSDate timeIntervalSinceReferenceDate];
    }
    
    if ( self.stateChanged )
    {
        ((BlockTypeVarg)self.stateChanged)( self );
    }
    
    triggerAfter( self, stateChanged );
    
    return YES;
}

- (BOOL)send
{
    @autoreleasepool
    {
        return [[LHHSignalBus sharedLHHSignalBus] send:self];
    };
}

- (BOOL)forward
{
    @autoreleasepool
    {
        return [[LHHSignalBus sharedLHHSignalBus] forward:self];
    };
}

- (BOOL)forward:(id)target
{
    @autoreleasepool
    {
        return [[LHHSignalBus sharedLHHSignalBus] forward:self to:target];
    };
}

- (NSTimeInterval)timeElapsed
{
    return _arriveTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostPending
{
    return _sendTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostExecution
{
    return _arriveTimeStamp - _sendTimeStamp;
}

- (void)log:(id)target
{
    if ( self.arrived || self.dead )
        return;
    
    if ( target )
    {
        if ( nil == self.jumpPath )
        {
            self.jumpPath = [[NSMutableArray alloc] init];
        }
        
        [self.jumpPath addObject:[target signalDescription]];
    }
}

#pragma mark -

- (NSMutableDictionary *)inputOrOutput
{
    if ( SignalState_Inited == _state )
    {
        if ( nil == self.input )
        {
            self.input = [NSMutableDictionary dictionary];
        }
        
        return self.input;
    }
    else
    {
        if ( nil == self.output )
        {
            self.output = [NSMutableDictionary dictionary];
        }
        
        return self.output;
    }
}

- (id)objectForKey:(id)key
{
    NSMutableDictionary * objects = [self inputOrOutput];
    return [objects objectForKey:key];
}

- (BOOL)hasObjectForKey:(id)key
{
    NSMutableDictionary * objects = [self inputOrOutput];
    return [objects objectForKey:key] ? YES : NO;
}

- (void)setObject:(id)value forKey:(id)key
{
    NSMutableDictionary * objects = [self inputOrOutput];
    [objects setObject:value forKey:key];
}

- (void)removeObjectForKey:(id)key
{
    NSMutableDictionary * objects = [self inputOrOutput];
    [objects removeObjectForKey:key];
}

- (void)removeAllObjects
{
    NSMutableDictionary * objects = [self inputOrOutput];
    [objects removeAllObjects];
}

- (id)objectForKeyedSubscript:(id)key;
{
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    [self setObject:obj forKey:key];
}


@end
