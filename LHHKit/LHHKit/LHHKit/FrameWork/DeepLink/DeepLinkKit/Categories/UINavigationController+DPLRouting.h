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


@import UIKit;

@interface UINavigationController (DPLRouting)

/**
 Places a view controller in the receivers view controller stack.
 @param targetViewController The view controller to be placed in/on to the stack.
 @note The `targetViewController' is pushed or inserted into the stack replacing any pre-existing instances of the same class. If the `targetViewController' instance is already in the stack, it will become the `topViewController'.
 */
- (void)DPL_placeTargetViewController:(UIViewController *)targetViewController;

@end
