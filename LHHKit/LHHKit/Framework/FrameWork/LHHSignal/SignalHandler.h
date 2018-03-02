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

@class SignalHandler;

@interface NSObject(BlockHandler)

- (SignalHandler *)blockHandlerOrCreate;
- (SignalHandler *)blockHandler;

- (void)addBlock:(id)block forName:(NSString *)name;
- (void)removeBlockForName:(NSString *)name;
- (void)removeAllBlocks;

@end

#pragma mark -

@interface SignalHandler : NSObject

- (BOOL)trigger:(NSString *)name;
- (BOOL)trigger:(NSString *)name withObject:(id)object;

- (void)addHandler:(id)handler forName:(NSString *)name;
- (void)removeHandlerForName:(NSString *)name;
- (void)removeAllHandlers;

@end
