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

@interface UIBorderView : UIView
@property (nonatomic, assign) CGFloat lineWidth;
@end

@protocol UIStyler <NSObject>
@property (nonatomic, strong) NSDictionary * styles;
@end

@interface UIView (NibStyle)

#pragma mark -

@property (nonatomic) NSString * nibBackgroundColor;
@property (nonatomic) id nibBorderColor;
@property (nonatomic) NSNumber * nibBorderWidth;
@property (nonatomic) BOOL nibOnePixelBorder;
@property (nonatomic) NSString * nibBorder;
@property (nonatomic) NSNumber * nibCornerRadius;
@property (nonatomic) NSString * nibCornerAutoRadius;
@property (nonatomic) NSNumber * nibAlpha;

@property (nonatomic, copy) NSString *styleId;
@property (nonatomic, copy) NSString *styleClass;

@property (nonatomic, strong) UIBorderView *	topBorder;
@property (nonatomic, strong) UIBorderView *	leftBorder;
@property (nonatomic, strong) UIBorderView *	rightBorder;
@property (nonatomic, strong) UIBorderView *	bottomBorder;

+ (void)setGlobalStyler:(id<UIStyler>)styler;

@end
