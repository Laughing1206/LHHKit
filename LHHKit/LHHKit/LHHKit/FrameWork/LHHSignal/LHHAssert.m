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

#import "LHHAssert.h"

#pragma mark -

@implementation LHHAsserter

SingletonImplemention(LHHAsserter)

@def_prop_assign( BOOL,    enabled );

+ (void)classAutoLoad
{
    [LHHAsserter sharedLHHAsserter];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        _enabled = YES;
    }
    return self;
}

- (void)toggle
{
    _enabled = _enabled ? NO : YES;
}

- (void)enable
{
    _enabled = YES;
}

- (void)disable
{
    _enabled = NO;
}

- (void)file:(const char *)file line:(NSUInteger)line func:(const char *)func flag:(BOOL)flag expr:(const char *)expr
{
    if ( NO == _enabled )
        return;
    
    if ( NO == flag )
    {
#if __SAMURAI_DEBUG__
        
        fprintf( stderr,
                "                        \n"
                "    %s @ %s (#%lu)       \n"
                "    {                   \n"
                "        ASSERT( %s );   \n"
                "        ^^^^^^          \n"
                "        Assertion failed\n"
                "    }                   \n"
                "                        \n", func, [[@(file) lastPathComponent] UTF8String], (unsigned long)line, expr );
        
#endif
        
        abort();
    }
}

@end

#pragma mark -

#if __cplusplus
extern "C"
#endif
void LHHAssert( const char * file, NSUInteger line, const char * func, BOOL flag, const char * expr )
{
    [[LHHAsserter sharedLHHAsserter] file:file line:line func:func flag:flag expr:expr];
}

