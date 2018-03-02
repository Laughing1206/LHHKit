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

/** Block extensions for NSMutableDictionary.

 These utilities expound upon the BlocksKit additions to the immutable
 superclass by allowing certain utilities to work on an instance of the mutable
 class, saving memory by not creating an immutable copy of the results.

 Includes code by the following:

 - [Martin Schürrer](https://github.com/MSch)
 - [Zach Waldowski](https://github.com/zwaldowski)

 @see NSDictionary(BlocksKit)
 */
@interface NSMutableDictionary (BlocksKit)

/** Filters a mutable dictionary to the key/value pairs matching the block.

  block A BOOL-returning code block for a key/value pair.
 @see <NSDictionary(BlocksKit)>bk_reject:
 */
- (void)bk_performSelect:(BOOL (^)(id key, id obj))block;

/** Filters a mutable dictionary to the key/value pairs not matching the block,
 the logical inverse to bk_select:.

  block A BOOL-returning code block for a key/value pair.
 @see <NSDictionary(BlocksKit)>bk_select:
 */
- (void)bk_performReject:(BOOL (^)(id key, id obj))block;

/** Transform each value of the dictionary to a new value, as returned by the
 block.

  block A block that returns a new value for a given key/value pair.
 @see <NSDictionary(BlocksKit)>bk_map:
 */
- (void)bk_performMap:(id (^)(id key, id obj))block;

@end
