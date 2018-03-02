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

@interface UINavigationBar (Extension)

@property (nonatomic, assign) CGFloat navAlpha;

- (void)hideBottomHairline;
- (void)showBottomHairline;

@end

@interface UINavigationController (NavAlpha)

@end

@interface UIViewController (NavAlpha)

// navAlpha
@property (nonatomic, assign) CGFloat navAlpha;

// navbackgroundColor
@property (null_resettable, nonatomic, strong) UIColor *navBarTintColor;

// tintColor
@property (null_resettable, nonatomic, strong) UIColor *navTintColor;

// titleColor
@property (null_resettable, nonatomic, strong) UIColor *navTitleColor;

@end
