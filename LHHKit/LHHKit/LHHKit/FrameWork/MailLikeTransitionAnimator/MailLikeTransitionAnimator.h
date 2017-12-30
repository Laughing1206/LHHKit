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


/*******
 
## Example:
 
### 1. To be presented ViewController :

```
@interface ToBePresentedViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) MailLikeTransitionAnimator * animator;
@end
```
 
### 2. Set the transitioning delegate be self

```
- (void)viewDidLoad
{
	self.transitioningDelegate = self.animator;
}
```

### 3. Implement the delegate, just copy the following code to your vc.m

```
@implementation ToBePresentedViewController
 
#pragma mark - MailLikeTransitionAnimator
 
- (MailLikeTransitionAnimator *)animator
{
	if ( !_animator ) {
		_animator = [MailLikeTransitionAnimator new];
		_animator.viewController = self;
	}
	return _animator;
}

@end
```

### 4. Just present the ViewController as you always do

```
ToBePresentedViewController * vc = [ToBePresentedViewController new];
[self presentViewController:vc animated:YES completion:nil];
```
 
*******/

#import <Foundation/Foundation.h>
@import UIKit;

@interface MailLikeTransitionAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>
@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, assign) BOOL isInterative;
@property (nonatomic, assign) BOOL canSwipeDown;
@property (nonatomic, assign) BOOL isRightOut;
@property (nonatomic, assign) float ratio;
@property (nonatomic, copy) void (^ whenBackgroundClicked)(void);
@property (nonatomic, weak) UIViewController * viewController;
@end
