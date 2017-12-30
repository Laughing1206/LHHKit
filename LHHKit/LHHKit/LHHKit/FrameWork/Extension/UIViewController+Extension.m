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


#import "UIViewController+Extension.h"
#import <objc/runtime.h>

@implementation UIViewController (Extension)

- (UIViewController *)previousViewController
{
    UINavigationController * nav = self.navigationController;
    if ( nav )
    {
        NSArray * controllers = nav.viewControllers;
        if ( 0 == controllers.count )
            return nil;
        
        NSInteger index = [controllers indexOfObject:self];
        if ( NSNotFound == index )
            return nil;
        
        if ( index > 0 )
        {
            return [controllers objectAtIndex:(index - 1)];
        }
    }
    
    return nil;
}

- (UIViewController *)nextViewController
{
    UINavigationController * nav = self.navigationController;
    if ( nav )
    {
        NSArray *    controllers = nav.viewControllers;
        NSInteger    index = [controllers indexOfObject:self];
        
        if ( controllers.count > 1 && (index + 1) < controllers.count )
        {
            return [controllers objectAtIndex:(index + 1)];
        }
    }
    
    return nil;
}


- (void)displayChildViewController:(UIViewController*)childViewController
{
    [childViewController willMoveToParentViewController:self];
    childViewController.view.frame = self.view.bounds;
    [self.view addSubview:childViewController.view];
    [self addChildViewController:childViewController];
    [childViewController didMoveToParentViewController:self];
}

- (void)hideChildViewController:(UIViewController*)childViewController
{
    [childViewController willMoveToParentViewController:nil];
    [childViewController.view removeFromSuperview];
    [childViewController removeFromParentViewController];
    [childViewController didMoveToParentViewController:nil];
}
@end

static const char kUIViewControllerDataKey;

@implementation UIViewController (Data)

@dynamic data;

- (void)setData:(id)data
{
    [self dataWillChange];
    
    objc_setAssociatedObject(self, &kUIViewControllerDataKey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dataDidChange];
}

- (id)data
{
    return objc_getAssociatedObject(self, &kUIViewControllerDataKey);
}

- (void)dataDidChange
{
    // to implement
}

- (void)dataWillChange
{
    // to implement
}

@end

static const char kDidSetupConstraintsKey;

@implementation UIViewController (Nib)

@dynamic didSetupConstraints;

- (void)setDidSetupConstraints:(BOOL)didSetupConstraints
{
    objc_setAssociatedObject(self, &kDidSetupConstraintsKey, @(didSetupConstraints), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)didSetupConstraints
{
    return [objc_getAssociatedObject(self, &kDidSetupConstraintsKey) boolValue];
}

+ (instancetype)loadFromNib
{
    return [[self alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
}

+ (instancetype)loadFromStoryBoard:(NSString *)storyBoard
{
    UIViewController * board = [[UIStoryboard storyboardWithName:storyBoard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return board;
}

+ (instancetype)loadInitialViewControllerFromStoryBoard:(NSString *)storyBoard
{
    UIViewController * board = [[UIStoryboard storyboardWithName:storyBoard bundle:nil] instantiateInitialViewController];
    return board;
}

/**
 *  @brief 自定义界面，如尺寸，位置
 */
- (void)customize
{
    
}

@end

@implementation UIViewController (TransparentUINavigationbar)

- (void)setNavigationBarTransparent:(BOOL)transparent
{
    if ( transparent )
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:nil
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = nil;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.view.backgroundColor = self.navigationController.navigationBar.tintColor;
    }
}

+ (void)setNavigationBarTransparent:(BOOL)transparent
{
    if ( transparent )
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
                                           forBarMetrics:UIBarMetricsDefault];
        [UINavigationBar appearance].shadowImage = [UIImage new];
    }
    else
    {
        [[UINavigationBar appearance] setBackgroundImage:nil
                                           forBarMetrics:UIBarMetricsDefault];
        [UINavigationBar appearance].shadowImage = nil;
    }
}

@end
