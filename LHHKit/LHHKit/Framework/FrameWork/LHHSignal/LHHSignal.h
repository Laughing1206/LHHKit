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

#import <Foundation/Foundation.h>

#pragma mark -

#undef    signal
#define signal( name ) \
static_property( name )

#undef    def_signal
#define def_signal( name ) \
def_static_property2( name, @"signal", NSStringFromClass([self class]) )

#undef    def_signal_alias
#define def_signal_alias( name, alias ) \
alias_static_property( name, alias )

#undef    makeSignal
#define    makeSignal( ... ) \
macro_string( macro_join(signal, __VA_ARGS__) )

#undef    handleSignal
#define    handleSignal( ... ) \
- (void) macro_join( handleSignal, __VA_ARGS__):(LHHSignal *)signal

#pragma mark -

typedef NSObject *    (^ LHHSignalBlock )( NSString * name, id object );
typedef id        BlockType;
typedef void (^ BlockTypeVoid )( void );
typedef void (^ BlockTypeVarg )( id first, ... );

#pragma mark -

typedef enum
{
    SignalState_Inited = 0,
    SignalState_Sending,
    SignalState_Arrived,
    SignalState_Dead
} SignalState;

#pragma mark -

@class LHHSignal;

@interface NSObject(SignalResponder)

@prop_readonly( LHHSignalBlock, onSignal );
@prop_readonly( NSMutableArray *,    userResponders );

- (id)signalResponders;                // override point
- (id)signalAlias;                    // override point
- (NSString *)signalNamespace;        // override point
- (NSString *)signalTag;            // override point
- (NSString *)signalDescription;    // override point

- (BOOL)hasSignalResponder:(id)obj;
- (void)addSignalResponder:(id)obj;
- (void)removeSignalResponder:(id)obj;
- (void)removeAllSignalResponders;

- (void)handleSignal:(LHHSignal *)that;

@end

#pragma mark -

@interface NSObject(SignalSender)

- (LHHSignal *)sendSignal:(NSString *)name;
- (LHHSignal *)sendSignal:(NSString *)name withObject:(NSObject *)object;
- (LHHSignal *)sendSignal:(NSString *)name from:(id)source;
- (LHHSignal *)sendSignal:(NSString *)name from:(id)source withObject:(NSObject *)object;

@end

#pragma mark -

@interface LHHSignal : NSObject<NSDictionaryProtocol, NSMutableDictionaryProtocol>

@joint( stateChanged );

@prop_unsafe( id,                        source );
@prop_unsafe( id,                        target );

@prop_copy( BlockType,                    stateChanged );
@prop_assign( SignalState,                state );
@prop_assign( BOOL,                        sending );
@prop_assign( BOOL,                        arrived );
@prop_assign( BOOL,                        dead );

@prop_assign( BOOL,                        hit );
@prop_assign( NSUInteger,                hitCount );
@prop_readonly( NSString *,                prettyName );

@prop_strong( NSString *,                name );
@prop_strong( id,                        object );
@prop_strong( NSMutableDictionary *,    input );
@prop_strong( NSMutableDictionary *,    output );

@prop_assign( NSTimeInterval,            initTimeStamp );
@prop_assign( NSTimeInterval,            sendTimeStamp );
@prop_assign( NSTimeInterval,            arriveTimeStamp );

@prop_readonly( NSTimeInterval,            timeElapsed );
@prop_readonly( NSTimeInterval,            timeCostPending );
@prop_readonly( NSTimeInterval,            timeCostExecution );

@prop_assign( NSInteger,                jumpCount );
@prop_strong( NSMutableArray *,            jumpPath );

+ (LHHSignal *)signal;
+ (LHHSignal *)signal:(NSString *)name;

- (BOOL)is:(NSString *)name;

- (BOOL)send;
- (BOOL)forward;
- (BOOL)forward:(id)target;

- (void)log:(id)source;

- (BOOL)changeState:(SignalState)newState;
@end

