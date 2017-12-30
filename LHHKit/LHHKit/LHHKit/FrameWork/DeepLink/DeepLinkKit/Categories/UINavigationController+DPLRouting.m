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

#import "UINavigationController+DPLRouting.h"

@implementation UINavigationController (DPLRouting)

- (void)DPL_placeTargetViewController:(UIViewController *)targetViewController {
    
    if ([self.viewControllers containsObject:targetViewController]) {
        [self popToViewController:targetViewController animated:NO];
    }
    else {
        
        for (UIViewController *controller in self.viewControllers) {
            if ([controller isMemberOfClass:[targetViewController class]]) {
                
                [self popToViewController:controller animated:NO];
                [self popViewControllerAnimated:NO];
                
                if ([controller isEqual:self.topViewController]) {
                    [self setViewControllers:@[targetViewController] animated:NO];
                }
                
                break;
            }
        }
        
        if (![self.topViewController isEqual:targetViewController]) {
            [self pushViewController:targetViewController animated:NO];
        }
    }
}

@end
