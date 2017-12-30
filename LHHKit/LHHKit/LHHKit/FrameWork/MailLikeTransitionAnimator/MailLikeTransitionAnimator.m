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


#import "MailLikeTransitionAnimator.h"

@interface UIView (MailLikeTransitionAnimatorPrivateT)
- (UIImage *)mlt_screenshot;
@end

@interface MailLikeTransitionAnimator ()
@property (nonatomic, weak) UIView * snapshotView;
@property (nonatomic, weak) UIButton * mask;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning>transitionContext;
@property (nonatomic, assign) BOOL isGestureValid;
@end

@implementation MailLikeTransitionAnimator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ratio = -1;
        self.isGestureValid = YES;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    CGFloat duration = [self transitionDuration:transitionContext];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIView *containerView = [transitionContext containerView];
    BOOL shouldHack = ([[UIDevice currentDevice].systemVersion compare:@"8.0"] != NSOrderedDescending);
                            
    // iOS 8 containerView 不会清subviews，但是iOS7之前会，所以加在window上
    UIView *canvasView = shouldHack ? [UIApplication sharedApplication].delegate.window : containerView;

    CGFloat ratio = 1;

    if ( self.ratio < 0 )
    {
        ratio = 0.92;

        if ( [UIScreen mainScreen].bounds.size.height == 736 )
        {
            ratio = 0.95;
        }
    }
    else
    {
        ratio = self.ratio;
    }

    CGFloat deltaHeight = 0;
    
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if ( self.isPresenting )
    {
        UIImageView * fromView = [[UIImageView alloc] initWithImage:[from.view mlt_screenshot]];
        fromView.frame = from.view.frame;
        [canvasView addSubview:fromView];

        self.snapshotView = fromView;
        
        UIButton * mask = [UIButton buttonWithType:UIButtonTypeCustom];
		[mask addTarget:self action:@selector(clickedMask:) forControlEvents:UIControlEventTouchUpInside];
        mask.backgroundColor = [UIColor blackColor];
        mask.frame = fromView.frame;
        mask.alpha = 0;
        
        [canvasView addSubview:mask];

        self.mask = mask;
		
        if ( shouldHack )
        {
            [canvasView sendSubviewToBack:mask];
            [canvasView sendSubviewToBack:fromView];
        }

        // 隐藏上一个 ViewController.view
        from.view.alpha = 0.f;

//        CATransform3D fromFinalTrans = CATransform3DMakeScale(ratio, ratio, 1);//将截图变形
        CATransform3D fromFinalTrans = CATransform3DMakeScale(1, 1, 1);
        CGRect finalPosition = [transitionContext finalFrameForViewController:to];

		if ( self.isRightOut )
		{
			finalPosition.origin.x = deltaHeight;

			to.view.frame = CGRectOffset(finalPosition, bounds.size.width, 0);
		}
		else
		{
			finalPosition.origin.y = deltaHeight;

			to.view.frame = CGRectOffset(finalPosition, 0, bounds.size.height);
		}

        [canvasView addSubview:to.view];

        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
							 if ( !self.isRightOut )
							 {
								 fromView.layer.transform = fromFinalTrans;
							 }

                             to.view.frame = finalPosition;
                             mask.alpha = 0.5;

                         } completion:^(BOOL finished) {
                             if ( !transitionContext.transitionWasCancelled ) {
                                 from.view.alpha = 1.f;
                                 [transitionContext completeTransition:YES];
                             } else {
                                 [transitionContext completeTransition:NO];
                             }
                         }];
    }
    else
    {
        CGRect finalPosition = from.view.frame;

		if ( self.isRightOut )
		{
			finalPosition.origin.x = finalPosition.size.width;
		}
		else
		{
			finalPosition.origin.y = finalPosition.size.height;
		}

        UIView * fromView = self.snapshotView;
        UIView * mask = self.mask;
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             fromView.layer.borderWidth = 0;
                             fromView.layer.transform = CATransform3DIdentity;
                             from.view.frame = finalPosition;
                             mask.alpha = 0.f;
                         } completion:^(BOOL finished) {
                             if ( !transitionContext.transitionWasCancelled ) {
                                 [fromView removeFromSuperview];
                                 self.snapshotView = nil;
                                 [mask removeFromSuperview];
                                 self.mask = nil;
                                 [transitionContext completeTransition:YES];
                             } else {
                                 to.view.frame = finalPosition;
                                 mask.alpha = 0.5;
                                 [transitionContext completeTransition:NO];
                             }
                         }];
    }
}

#pragma mark - UIPercentDrivenInteractiveTransition

- (void)setViewController:(UIViewController *)viewController
{
    if ( _viewController == viewController )
    {
        return;
    }
    
    _viewController = viewController;
    
    if ( self.canSwipeDown ) {
        [self prepareGestureRecognizerInView:viewController.view];
    }
}

- (void)prepareGestureRecognizerInView:(UIView *)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view.superview];
    
    CGFloat progress = translation.y / (bounds.size.height * 1.0);
    
    progress = MIN(1.0, MAX(0.0, progress));
    
    switch ( gestureRecognizer.state )
    {
        case UIGestureRecognizerStateBegan: {
                if ( velocity.y < 0 ) {
                    self.isGestureValid = NO;
                } else {
                    self.isGestureValid = YES;
                    // 1. Mark the interacting flag. Used when supplying it in delegate.
                    self.isInterative = YES;
                    [self.viewController dismissViewControllerAnimated:YES completion:nil];
                }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if ( self.isGestureValid )
            {
                // 2. Calculate the percentage of guesture
                [self updateInteractiveTransition:progress];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if ( self.isGestureValid )
            {
                // 2. Calculate the percentage of guesture
                [self updateInteractiveTransition:progress];

                self.isInterative = NO;
                if ( velocity.y > 200 ) {
                    [self finishInteractiveTransition];
                } else {
                    // completionSpeed 不能为 0
                    [self cancelInteractiveTransition];
                }
            }
            self.isGestureValid = YES;
        }
        default:
            break;
    }
}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)clickedMask:(id)sender
{
	if ( self.whenBackgroundClicked ) {
		self.whenBackgroundClicked();
	}
}

#pragma mark - 

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
																   presentingController:(UIViewController *)presenting
																	   sourceController:(UIViewController *)source
{
	self.isPresenting = YES;
	return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
	self.isPresenting = NO;
	return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
	return self.isInterative ? self : nil;
}

@end

#pragma mark -

@implementation UIView (MailLikeTransitionAnimatorPrivateT)

- (UIImage *)mlt_screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        
        NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:
                               [self methodSignatureForSelector:
                                @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invoc setTarget:self];
        [invoc setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect arg2 = self.bounds;
        BOOL arg3 = YES;
        [invoc setArgument:&arg2 atIndex:2];
        [invoc setArgument:&arg3 atIndex:3];
        [invoc invoke];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
