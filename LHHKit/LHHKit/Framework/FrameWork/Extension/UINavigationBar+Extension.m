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


#import "UINavigationBar+Extension.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Extension)
static char * navAlphaKey = "navAlphaKey";

- (CGFloat)navAlpha
{
    if (objc_getAssociatedObject(self, navAlphaKey) == nil)
    {
        return 1;
    }
    return [objc_getAssociatedObject(self, navAlphaKey) floatValue];
}
- (void)setNavAlpha:(CGFloat)navAlpha
{
    CGFloat alpha = MAX(MIN(navAlpha, 1), 0);// 必须在 0~1的范围
    
    UIView *barBackground = self.subviews[0];
    if (self.translucent == NO || [self backgroundImageForBarMetrics:UIBarMetricsDefault] != nil) {
        barBackground.alpha = alpha;
        
    } else {
        
        if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0) {
            UIView *effectFilterView = barBackground.subviews.lastObject;
            effectFilterView.alpha = alpha;
        } else {
            UIView *effectFilterView = barBackground.subviews.firstObject;
            effectFilterView.alpha = alpha;
        }
    }
    /// 黑线
    UIImageView *shadowView = [barBackground valueForKey:@"_shadowView"];
    if (alpha < 0.01) {
        shadowView.hidden = YES;
    } else {
        shadowView.hidden = NO;
        shadowView.alpha = alpha;
    }
    
    objc_setAssociatedObject(self, navAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/**
 * Hide 1px hairline of the nav bar
 */
- (void)hideBottomHairline {
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self];
    navBarHairlineImageView.hidden = YES;
}

/**
 * Show 1px hairline of the nav bar
 */
- (void)showBottomHairline {
    // Show 1px hairline of translucent nav bar
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self];
    navBarHairlineImageView.hidden = NO;
}


- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView * subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end

@implementation UINavigationController (NavAlpha)

/// UINavigationBar
-(void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    navigationBar.tintColor = self.topViewController.navTintColor;
    navigationBar.barTintColor = self.topViewController.navBarTintColor;
    navigationBar.navAlpha = self.topViewController.navAlpha;
}
-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    navigationBar.tintColor = self.topViewController.navTintColor;
    navigationBar.barTintColor = self.topViewController.navBarTintColor;
    navigationBar.navAlpha = self.topViewController.navAlpha;
    return YES;
}

@end

#pragma mark - UIViewController + NavAlpha

static char *vcAlphaKey = "vcAlphaKey";
static char *vcColorKey = "vcColorKey";
static char *vcNavtintColorKey = "vcNavtintColorKey";
static char *vcTitleColorKey = "vcTitleColorKey";

@implementation UIViewController (NavAlpha)

-(CGFloat)navAlpha {
    if (objc_getAssociatedObject(self, vcAlphaKey) == nil) {
        return 1;
    }
    return [objc_getAssociatedObject(self, vcAlphaKey) floatValue];
}
-(void)setNavAlpha:(CGFloat)navAlpha {
    CGFloat alpha = MAX(MIN(navAlpha, 1), 0);// 0~1
    self.navigationController.navigationBar.navAlpha = alpha;
    objc_setAssociatedObject(self, vcAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// backgroundColor
-(UIColor *)navBarTintColor {
    UIColor *color = objc_getAssociatedObject(self, vcColorKey);
    if (color == nil) {
        color = [UINavigationBar appearance].barTintColor;
    }
    return color;
}
-(void)setNavBarTintColor:(UIColor *)navBarTintColor {
    self.navigationController.navigationBar.barTintColor = navBarTintColor;
    objc_setAssociatedObject(self, vcColorKey, navBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// tintColor
-(UIColor *)navTintColor {
    UIColor *color = objc_getAssociatedObject(self, vcNavtintColorKey);
    if (color == nil) {
        color = [UINavigationBar appearance].tintColor;
    }
    return color;
}
-(void)setNavTintColor:(UIColor *)tintColor {
    self.navigationController.navigationBar.tintColor = tintColor;
    objc_setAssociatedObject(self, vcNavtintColorKey, tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// titleColor
- (UIColor *)navTitleColor {
    UIColor *color = objc_getAssociatedObject(self, vcTitleColorKey);
    
    if (color == nil) {
        color = self.navigationController.navigationBar.titleTextAttributes[NSForegroundColorAttributeName];
    }
    return color;
}

- (void)setNavTitleColor:(UIColor *)navTitleColor {
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = navTitleColor;
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
    objc_setAssociatedObject(self, vcTitleColorKey, navTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end

