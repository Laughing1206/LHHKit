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

@interface NSMapTable (BlocksKit)

/** Loops through the maptable and executes the given block using each item.

  block A block that performs an action using a key/value pair.
 */
- (void)bk_each:(void (^)(id key, id obj))block;

/** Loops through a maptable to find the first key/value pair matching the block.

 bk_match: is functionally identical to bk_select:, but will stop and return
 the value on the first match.

  block A BOOL-returning code block for a key/value pair.
 @return The value of the first pair found;
 */
- (id)bk_match:(BOOL (^)(id key, id obj))block;

/** Loops through a maptable to find the key/value pairs matching the block.

  block A BOOL-returning code block for a key/value pair.
 @return Returns a maptable of the objects found.
 */
- (NSMapTable *)bk_select:(BOOL (^)(id key, id obj))block;

/** Loops through a maptable to find the key/value pairs not matching the block.

 This selector performs *literally* the exact same function as bk_select: but in reverse.

 This is useful, as one may expect, for filtering objects.
 NSMapTable *strings = [userData bk_reject:^BOOL(id key, id value) {
   return ([obj isKindOfClass:[NSString class]]);
 }];

  block A BOOL-returning code block for a key/value pair.
 @return Returns a maptable of all objects not found.
 */
- (NSMapTable *)bk_reject:(BOOL (^)(id key, id obj))block;

/** Call the block once for each object and create a maptable with the same keys
 and a new set of values.

  block A block that returns a new value for a key/value pair.
 @return Returns a maptable of the objects returned by the block.
 */
- (NSMapTable *)bk_map:(id (^)(id key, id obj))block;

/** Loops through a maptable to find whether any key/value pair matches the block.

 This method is similar to the Scala list `exists`. It is functionally
 identical to bk_match: but returns a `BOOL` instead. It is not recommended
 to use bk_any: as a check condition before executing bk_match:, since it would
 require two loops through the maptable.

  block A two-argument, BOOL-returning code block.
 @return YES for the first time the block returns YES for a key/value pair, NO otherwise.
 */
- (BOOL)bk_any:(BOOL (^)(id key, id obj))block;

/** Loops through a maptable to find whether no key/value pairs match the block.

 This selector performs *literally* the exact same function as bk_all: but in reverse.

  block A two-argument, BOOL-returning code block.
 @return YES if the block returns NO for all key/value pairs in the maptable, NO otherwise.
 */
- (BOOL)bk_none:(BOOL (^)(id key, id obj))block;

/** Loops through a maptable to find whether all key/value pairs match the block.

  block A two-argument, BOOL-returning code block.
 @return YES if the block returns YES for all key/value pairs in the maptable, NO otherwise.
 */
- (BOOL)bk_all:(BOOL (^)(id key, id obj))block;

/** Filters a mutable dictionary to the key/value pairs matching the block.

  block A BOOL-returning code block for a key/value pair.
 @see <NSMapTable(BlocksKit)>bk_reject:
 */
- (void)bk_performSelect:(BOOL (^)(id key, id obj))block;

/** Filters a mutable dictionary to the key/value pairs not matching the block,
 the logical inverse to bk_select:.

  block A BOOL-returning code block for a key/value pair.
 @see <NSMapTable(BlocksKit)>bk_select:
 */
- (void)bk_performReject:(BOOL (^)(id key, id obj))block;

/** Transform each value of the dictionary to a new value, as returned by the
 block.

  block A block that returns a new value for a given key/value pair.
 @see <NSMapTable(BlocksKit)>bk_map:
 */
- (void)bk_performMap:(id (^)(id key, id obj))block;

@end
