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


#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

@property (nonatomic, readonly) UIViewController * previousViewController;
@property (nonatomic, readonly) UIViewController * nextViewController;

- (void)displayChildViewController:(UIViewController*)childViewController;
- (void)hideChildViewController:(UIViewController*)childViewController;

@end

@interface UIViewController (Data)

@property (nonatomic, strong) id data;

- (void)dataDidChange;
- (void)dataWillChange;

@end

@interface UIViewController (Nib)

@property (nonatomic, assign) BOOL didSetupConstraints;

+ (instancetype)loadFromNib;
+ (instancetype)loadFromStoryBoard:(NSString *)storyBoard;
+ (instancetype)loadInitialViewControllerFromStoryBoard:(NSString *)storyBoard;

/**
 *  @brief 自定义界面，如尺寸，位置
 */
- (void)customize;

@end

@interface UIViewController (TransparentUINavigationbar)
/**
 *  Transparent current ViewController's UINavigationbar
 */
- (void)setNavigationBarTransparent:(BOOL)transparent;

/**
 *  Transparent all ViewController's UINavigationbar
 */
+ (void)setNavigationBarTransparent:(BOOL)transparent;

@end

