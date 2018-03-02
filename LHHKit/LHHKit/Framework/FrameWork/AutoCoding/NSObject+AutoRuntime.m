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

#import "NSObject+AutoRuntime.h"
#import <objc/runtime.h>

static const char kNSObjectConformedProtocolsKey;
static NSMutableDictionary * kProtocolMap = nil;

@implementation NSObject (AutoRuntime)

+ (NSArray *)conformedProtocols
{
    NSArray * _protocols = objc_getAssociatedObject(self, &kNSObjectConformedProtocolsKey);
    
    if ( !_protocols )
    {
        unsigned int outCount = 0;
        __unsafe_unretained Protocol **protocols = class_copyProtocolList([self class], &outCount);
        
        if ( outCount > 0 )
        {
            NSMutableArray * protocolArray = [[NSMutableArray alloc] initWithCapacity:outCount];
            
            for (NSInteger i = 0; i < outCount; i++)
            {
                const char * name = protocol_getName(protocols[i]);
                NSString * nameString = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
                [protocolArray addObject:nameString];
            }
            
            _protocols = [protocolArray copy];
        }
        
        free(protocols);
        
        objc_setAssociatedObject(self, &kNSObjectConformedProtocolsKey, _protocols, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _protocols;
}

@end
