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

/** BlocksKit extensions for NSInvocation. */
@interface NSInvocation (BlocksKit)

/** Generates a forwarding `NSInvocation` instance for a given method call
 encapsulated by the given block.

	NSInvocation *invocation = [NSInvocation invocationWithTarget:target block:^(id myObject) {
		[myObject someMethodWithArg:42.0];
	}];

 This returns an invocation with the appropriate target, selector, and arguments
 without creating the buffers yourself. It is only recommended to call a method
 on the argument to the block only once. More complicated forwarding machinery
 can be accomplished by the A2DynamicDelegate family of classes included in
 BlocksKit.

 Created by [Jonathan Rentzch](https://github.com/rentzsch) as
 `NSInvocation-blocks`.

  target The object to "grab" the block invocation from.
  block A code block.
 @return A fully-prepared instance of NSInvocation ready to be invoked.
 */
+ (NSInvocation *)bk_invocationWithTarget:(id)target block:(void (^)(id target))block;

@end
