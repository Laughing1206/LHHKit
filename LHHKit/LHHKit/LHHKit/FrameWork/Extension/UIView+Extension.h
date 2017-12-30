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

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);


@interface UIView (Extension)

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property (assign, nonatomic) CGFloat    top;
@property (assign, nonatomic) CGFloat    bottom;
@property (assign, nonatomic) CGFloat    left;
@property (assign, nonatomic) CGFloat    right;

@property (assign, nonatomic) CGPoint    offset;
@property (assign, nonatomic) CGPoint    position;

@property (assign, nonatomic) CGFloat    x;
@property (assign, nonatomic) CGFloat    y;
@property (assign, nonatomic) CGFloat    w;
@property (assign, nonatomic) CGFloat    h;

@property (assign, nonatomic) CGFloat    width;
@property (assign, nonatomic) CGFloat    height;
@property (assign, nonatomic) CGSize     size;

@property (assign, nonatomic) CGFloat    centerX;
@property (assign, nonatomic) CGFloat    centerY;
@property (assign, nonatomic) CGPoint    origin;
@property (readonly, nonatomic) CGPoint  boundsCenter;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

- (UIViewController *)viewController;

/** 返回圆角图片 */
- (void)addCornerMaskLayerWithRadius:(CGFloat)radius;

@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
@property (nonatomic, strong)IBInspectable UIColor *borderColor;
@property (nonatomic, strong)IBInspectable UIColor *shadowColor;
@property (nonatomic, assign)IBInspectable CGFloat shadowOpacity;

///默认tag ＝ 1000重用；
- (UILabel *)addLabel:(NSString *)title Font:(UIFont *)aFont Color:(UIColor *)aCol;
///会根据tag重用；
- (UILabel *)addLabel:(NSString *)title Font:(UIFont *)aFont Color:(UIColor *)aCol tag:(NSInteger)tag;
///根据属性字符串给lable添加string
- (UILabel *)addAttributedLabel:(NSString *)title Font:(UIFont *)aFont Color:(UIColor *)aCol;

///移除所有子视图
- (void)removeAllSubviews;

///给view的layer加边框
- (void)changeUIlayer;
///创建button
- (UIButton *)addButtonWithImage:(NSString *)btnString withTitle:(NSString *)aTitle withTag:(NSInteger)aTag;
///水平的线
- (UIView *)addHorizontalLineView;//水平线
///竖直的线
- (UIView *)addVerticalLineView;
///添加imgeview
- (UIImageView *)addImageViewWithString:(NSString *)imgString;
///添加一个标准button，用于fooerView的确定，退出登录等等
- (UIButton *)addBaseButton:(NSString *)titleString;
///添加一个view
- (UIView *)addViewWithColor:(NSString *)colorStr;

@end

@interface UIView (Tips)

- (void)presentMessageTips:(NSString *)message;
- (void)presentSuccessTips:(NSString *)message;
- (void)presentFailureTips:(NSString *)message;
- (void)presentLoadingTips:(NSString *)message;

- (void)dismissTips;

@end

#pragma mark - UIViewController

@interface UIViewController (Tips)

- (void)presentMessageTips:(NSString *)message;
- (void)presentSuccessTips:(NSString *)message;
- (void)presentFailureTips:(NSString *)message;
- (void)presentLoadingTips:(NSString *)message;

- (void)dismissTips;

@end

@interface UIView (Data)

@property (nonatomic, strong) id data;

- (void)dataDidChange;
- (void)dataWillChange;

@end

#ifndef LessThanOrEqual
#define LessThanOrEqual
#undef  LessThanOrEqual
#endif
#ifndef Equal
#define Equal
#undef  Equal
#endif
#ifndef GreaterThanOrEqual
#define GreaterThanOrEqual
#undef  GreaterThanOrEqual
#endif

#ifndef Left
#undef  Left
#define Left
#endif
#ifndef Right
#undef  Right
#define Right
#endif
#ifndef Top
#undef  Top
#define Top
#endif
#ifndef Bottom
#undef  Bottom
#define Bottom
#endif
#ifndef Leading
#undef  Leading
#define Leading
#endif
#ifndef Trailing
#undef  Trailing
#define Trailing
#endif
#ifndef Width
#undef  Width
#define Width
#endif
#ifndef Height
#undef  Height
#define Height
#endif
#ifndef CenterX
#undef  CenterX
#define CenterX
#endif
#ifndef CenterY
#undef  CenterY
#define CenterY
#endif
#ifndef Baseline
#undef  Baseline
#define Baseline
#endif
#ifndef LastBaseline
#undef  LastBaseline
#define LastBaseline
#endif
#ifndef FirstBaseline
#undef  FirstBaseline
#define FirstBaseline
#endif

#ifndef LeftMargin
#undef  LeftMargin
#define LeftMargin
#endif
#ifndef RightMargin
#undef  RightMargin
#define RightMargin
#endif
#ifndef TopMargin
#undef  TopMargin
#define TopMargin
#endif
#ifndef BottomMargin
#undef  BottomMargin
#define BottomMargin
#endif
#ifndef LeadingMargin
#undef  LeadingMargin
#define LeadingMargin
#endif
#ifndef TrailingMargin
#undef  TrailingMargin
#define TrailingMargin
#endif
#ifndef CenterXWithinMargins
#undef  CenterXWithinMargins
#define CenterXWithinMargins
#endif
#ifndef CenterYWithinMargins
#undef  CenterYWithinMargins
#define CenterYWithinMargins
#endif

// a.attr = b.attr * n + c

#define FKAutoLayoutPrepare(v) UIView * __xQxFxiXsXh = (v); (v).translatesAutoresizingMaskIntoConstraints = NO;
#define FKAutoLayoutActive(cs) [(__xQxFxiXsXh).superview addConstraints:(cs)]; __xQxFxiXsXh = nil;

#define FKAutoLayoutMakeSize(a, attr1, relation, c) \
[NSLayoutConstraint constraintWithItem:(a) \
attribute:NSLayoutAttribute##attr1 \
relatedBy:NSLayoutRelation##relation \
toItem:(nil) \
attribute:NSLayoutAttributeNotAnAttribute \
multiplier:1 \
constant:(c)]

#define FKAutoLayoutMake(a, attr1, relation, b, attr2, c) \
[NSLayoutConstraint constraintWithItem:(a) \
attribute:NSLayoutAttribute##attr1 \
relatedBy:NSLayoutRelation##relation \
toItem:(b) \
attribute:NSLayoutAttribute##attr2 \
multiplier:1 \
constant:(c)]

#define FKAutoLayoutMakeM(a, attr1, relation, b, attr2, n, c) \
[NSLayoutConstraint constraintWithItem:(a) \
attribute:NSLayoutAttribute##attr1 \
relatedBy:NSLayoutRelation##relation \
toItem:(b) \
attribute:NSLayoutAttribute##attr2 \
multiplier:(n) \
constant:(c)]


#define TO_STRING(x) TO_STRING1(x)
#define TO_STRING1(x) #x

@interface UIView (FKAutoLayout)

- (NSArray *)autoFillSuperView;
- (NSArray *)autoFillSuperViewWithInsets:(UIEdgeInsets)insets;

@end

@interface UIView (Nib)

+ (UINib *)nib;
+ (UINib *)nibWithName:(NSString *)name;

// 在 StoryBoard 或者 XIB 里复用另外一个 XIB
- (void)loadFromNib;

+ (instancetype)loadFromNib;
+ (instancetype)loadFromNib:(NSString *)nibName;
+ (instancetype)loadFromNibWithFrame:(CGRect)frame;

- (void)customize;

@end

@interface UIView (CornerMaskLayer)

@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
@property (nonatomic, strong)IBInspectable UIColor * borderColor;
@property (nonatomic, strong)IBInspectable UIColor * shadowColor;
@property (nonatomic, assign)IBInspectable CGFloat shadowOpacity;
@end
