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

@protocol NSMutableArrayProtocol <NSObject>
@required
- (void)addObject:(id)anObject;
@optional
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end

#pragma mark -

@interface NSMutableArray(Extension)<NSMutableArrayProtocol>

+ (NSMutableArray *)nonRetainingArray;            // copy from Three20

- (void)addUniqueObject:(id)object compare:(NSArrayCompareBlock)compare;
- (void)addUniqueObjects:(const id [])objects count:(NSUInteger)count compare:(NSArrayCompareBlock)compare;
- (void)addUniqueObjectsFromArray:(NSArray *)array compare:(NSArrayCompareBlock)compare;

- (void)unique;
- (void)unique:(NSArrayCompareBlock)compare;

- (void)sort;
- (void)sort:(NSArrayCompareBlock)compare;

- (void)shrink:(NSUInteger)count;
- (void)append:(id)object;

- (NSMutableArray *)pushHead:(NSObject *)obj;
- (NSMutableArray *)pushHeadN:(NSArray *)all;
- (NSMutableArray *)popTail;
- (NSMutableArray *)popTailN:(NSUInteger)n;

- (NSMutableArray *)pushTail:(NSObject *)obj;
- (NSMutableArray *)pushTailN:(NSArray *)all;
- (NSMutableArray *)popHead;
- (NSMutableArray *)popHeadN:(NSUInteger)n;

- (NSMutableArray *)keepHead:(NSUInteger)n;
- (NSMutableArray *)keepTail:(NSUInteger)n;@end
