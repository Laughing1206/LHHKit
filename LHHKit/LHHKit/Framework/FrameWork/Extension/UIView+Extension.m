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


#import "UIView+Extension.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (Extension)

@dynamic top;
@dynamic bottom;
@dynamic left;
@dynamic right;

@dynamic width;
@dynamic height;

@dynamic offset;
@dynamic position;
@dynamic size;

@dynamic x;
@dynamic y;
@dynamic w;
@dynamic h;

// Query other frame locations
- (CGPoint) bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGFloat)w
{
    return self.frame.size.width;
}

- (void)setW:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)h
{
    return self.frame.size.height;
}

- (void)setH:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)offset
{
    CGPoint        point = CGPointZero;
    UIView *    view = self;
    
    while ( view )
    {
        point.x += view.frame.origin.x;
        point.y += view.frame.origin.y;
        
        view = view.superview;
    }
    
    return point;
}

- (void)setOffset:(CGPoint)offset
{
    UIView * view = self;
    if ( nil == view )
        return;
    
    CGPoint point = offset;
    
    while ( view )
    {
        point.x += view.superview.frame.origin.x;
        point.y += view.superview.frame.origin.y;
        
        view = view.superview;
    }
    
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

- (CGPoint)position
{
    return self.frame.origin;
}

- (void)setPosition:(CGPoint)pos
{
    CGRect frame = self.frame;
    frame.origin = pos;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)boundsCenter
{
    return CGPointMake( CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) );
}

// Move via offset
- (void) moveBy: (CGPoint) delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height))
    {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width))
    {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}

- (UIViewController *)viewController
{
    UIResponder *next = [self nextResponder];
    
    do {
        if ([next isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)addCornerMaskLayerWithRadius:(CGFloat)radius
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath;
    self.layer.mask = layer;
}

- (CGFloat)cornerRadius
{
    return [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue];
}
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}


- (CGFloat)borderWidth
{
    return [objc_getAssociatedObject(self, @selector(borderWidth)) floatValue];
}
- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}

- (UIColor *)borderColor
{
    return objc_getAssociatedObject(self, @selector(borderColor));
}
- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)shadowColor
{
    return objc_getAssociatedObject(self, @selector(shadowColor));
}
- (void)setShadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}

- (CGFloat)shadowOpacity
{
    return [objc_getAssociatedObject(self, @selector(shadowOpacity)) floatValue];
}
- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = shadowOpacity;
}

- (UILabel *)addLabel:(NSString *)title Font:(UIFont *)aFont Color:(UIColor *)aCol
{
    UILabel *label = [UILabel new];
    
    [self addSubview:label];
    label.textColor = aCol;
    label.font = aFont;
    if (title) {
        label.text = title;
    }
    return label;
}

- (UILabel *)addLabel:(NSString *)title Font:(UIFont *)aFont Color:(UIColor *)aCol tag:(NSInteger)tag
{
    UILabel *label = (UILabel *)[self viewWithTag:tag];
    if (!label) {
        label = [UILabel new];
        [self addSubview:label];
    }
    
    label.textColor = aCol;
    label.font = aFont;
    if (title) {
        label.text = title;
    }
    label.tag = tag;
    label.numberOfLines = 0;
    
    return label;
}

- (UIButton *)addButton:(NSString *)titleString
                   font:(UIFont *)font
             titleColor:(UIColor *)titleColor
        backgroundColor:(UIColor *)backgroundColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (titleString && titleString.length)
    {
        [button setTitle:titleString forState:UIControlStateNormal];
    }
    
    if (titleColor)
    {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    if (backgroundColor)
    {
        [button setBackgroundColor:backgroundColor];
    }
    
    if (font)
    {
        button.titleLabel.font = font;
    }
    [self addSubview:button];
    return button;
}

- (UILabel *)addAttributedLabel:(NSString *)title Font:(UIFont *)aFont Color:(UIColor *)aCol
{
    UILabel *label = [UILabel new];
    
    [self addSubview:label];
    label.textColor = aCol;
    label.font = aFont;
    if (title) {
        label.text = title;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    [paragraphStyle setLineSpacing:5];//调整行间距
    label.attributedText = attributedString;
    label.numberOfLines = 0;
    [label sizeToFit];
    
    return label;
}

- (void)removeAllSubviews
{
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)changeUIlayer
{
    self.layer.borderColor = [UIColor purpleColor].CGColor;
    self.layer.borderWidth = 0.5;
}

- (UIButton *)addButtonWithImage:(NSString *)btnString withTitle:(NSString *)aTitle withTag:(NSInteger)aTag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:btnString] forState:UIControlStateNormal];
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#606060"] forState:UIControlStateNormal];
    
    
    button.tag = aTag;
    [self addSubview:button];
    return button;
}

- (UIView *)addHorizontalLineView
{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = RGB(243,245,249);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
    }];
    return line;
}

- (UIView *)addVerticalLineView
{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
    }];
    return line;
}

- (UIImageView *)addImageViewWithString:(NSString *)imgString
{
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgString]];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.backgroundColor = [UIColor clearColor];
    [self addSubview:imgView];
    return imgView;
}

- (UIButton *)addBaseButton:(NSString *)titleString
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5;
    [button setTitle:titleString forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [button setBackgroundColor:RGB(233,97,19)];
    button.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self addSubview:button];
    return button;
}
- (UIView *)addViewWithColor:(NSString *)colorStr
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:colorStr];
    [self addSubview:view];
    return view;
}
@end

static const char kUIViewMBProgressHUDKey;

@interface UIView (PrivateTips)
@property (nonatomic, strong) MBProgressHUD * mb_hud;
@end

@implementation UIView (PrivateTips)

@dynamic mb_hud;

- (void)setMb_hud:(MBProgressHUD *)mb_hud
{
    objc_setAssociatedObject(self, &kUIViewMBProgressHUDKey, mb_hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)mb_hud
{
    return objc_getAssociatedObject(self, &kUIViewMBProgressHUDKey);
}

@end

#pragma mark-

@implementation UIView (Tips)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)showTips:(NSString *)message icon:(NSString *)icon autoHide:(BOOL)autoHide
{
    UIView * container = self;
    
    if ( container )
    {
        if ( nil != self.mb_hud )
        {
            [self.mb_hud hide:NO];
        }
        
        UIView * view = self;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.detailsLabelText = message;
        hud.opacity = 0.7;
        hud.detailsLabelFont = [UIFont systemFontOfSize:15];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
        if (icon && icon.length)
        {
            hud.mode = MBProgressHUDModeCustomView;
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
        }
        
        hud.removeFromSuperViewOnHide = YES;
        
        self.mb_hud = hud;
        
        if ( autoHide )
        {
            [hud hide:YES afterDelay:1.5f];
        }
    }
}

- (void)presentMessageTips:(NSString *)message
{
    [self setScrollEnabledWithLoading:NO];
    [self showTips:message icon:@"" autoHide:YES];
}

- (void)presentSuccessTips:(NSString *)message
{
    [self setScrollEnabledWithLoading:NO];
    [self showTips:message icon:@"success.png" autoHide:YES];
}

- (void)presentFailureTips:(NSString *)message
{
    [self setScrollEnabledWithLoading:NO];
    [self showTips:message icon:@"error.png" autoHide:YES];
}

- (void)setScrollEnabledWithLoading:(BOOL)isLoading
{
    if ([self isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *view = (UIScrollView *)self;
        view.scrollEnabled = NO;
        
        if (!isLoading)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
                
                view.scrollEnabled = YES;
            });
        }
    }
}

- (void)presentLoadingTips:(NSString *)message
{
    UIView * container = self;
    [self setScrollEnabledWithLoading:YES];
    if ( container )
    {
        if ( nil != self.mb_hud )
        {
            [self.mb_hud hide:NO];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:container animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.detailsLabelText = message;
        hud.opacity = 0.7;
        hud.detailsLabelFont = [UIFont systemFontOfSize:15];
        self.mb_hud = hud;
    }
}

- (void)dismissTips
{
    if ([self isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *view = (UIScrollView *)self;
        view.scrollEnabled = YES;
    }
    [self.mb_hud hide:YES];
    self.mb_hud = nil;
}
#pragma clang diagnostic pop
@end

@implementation UIViewController (Tips)

- (void)presentMessageTips:(NSString *)message
{
    [self setScrollEnabledWithLoading:NO];
    [self.view showTips:message icon:@"" autoHide:YES];
}

- (void)presentSuccessTips:(NSString *)message
{
    [self setScrollEnabledWithLoading:NO];
    [self.view showTips:message icon:@"success.png" autoHide:YES];
}

- (void)presentFailureTips:(NSString *)message
{
    [self setScrollEnabledWithLoading:NO];
    [self.view showTips:message icon:@"error.png" autoHide:YES];
}

- (void)presentLoadingTips:(NSString *)message
{
    [self setScrollEnabledWithLoading:YES];
    [self.view presentLoadingTips:message];
}

- (void)setScrollEnabledWithLoading:(BOOL)isLoading
{
    if ([self.view isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *view = (UIScrollView *)self.view;
        view.scrollEnabled = NO;
        
        if (!isLoading)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
                
                view.scrollEnabled = YES;
            });
        }
    }
}

- (void)dismissTips
{
    if ([self.view isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *view = (UIScrollView *)self.view;
        view.scrollEnabled = YES;
    }
    
    [self.view dismissTips];
}

@end

static const char kUIViewDataKey;

@implementation UIView (Data)

@dynamic data;

- (void)setData:(id)data
{
    [self dataWillChange];
    
    objc_setAssociatedObject(self, &kUIViewDataKey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dataDidChange];
}

- (id)data
{
    return objc_getAssociatedObject(self, &kUIViewDataKey);
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

@implementation UIView (FKAutoLayout)

- (NSArray *)autoFillSuperView
{
    return [self autoFillSuperViewWithInsets:UIEdgeInsetsZero];
}

- (NSArray *)autoFillSuperViewWithInsets:(UIEdgeInsets)insets
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * c1 = FKAutoLayoutMake(self, Leading, Equal, self.superview, Leading, insets.left);
    NSLayoutConstraint * c2 = FKAutoLayoutMake(self, Trailing, Equal, self.superview, Trailing, insets.right);
    NSLayoutConstraint * c3 = FKAutoLayoutMake(self, Top, Equal, self.superview, Top, insets.top);
    NSLayoutConstraint * c4 = FKAutoLayoutMake(self, Bottom, Equal, self.superview, Bottom, insets.bottom);
    
    NSArray * array = @[c1, c2, c3, c4];
    
    [self.superview addConstraints:array];
    
    return array;
}

@end

@implementation UIView (Nib)

+ (UINib *)nib
{
    return [self nibWithName:NSStringFromClass([self class])];
}

+ (UINib *)nibWithName:(NSString *)name
{
    return [UINib nibWithNibName:name bundle:[NSBundle mainBundle]];
}

+ (instancetype)loadFromNib
{
    return [self loadFromNib:NSStringFromClass([self class])];
}

+ (instancetype)loadFromNib:(NSString *)nibName
{
    return [[[self nibWithName:nibName] instantiateWithOwner:nil options:nil] firstObject];
}

+ (instancetype)loadFromNibWithFrame:(CGRect)frame
{
    UIView * nibView = [self loadFromNib];
    nibView.frame = frame;
    return nibView;
}

- (void)loadFromNib
{
    UIView * shadow = [[[[self class] nib] instantiateWithOwner:self options:nil] firstObject];
    
    [self addSubview:shadow];
    
    [shadow autoFillSuperView];
}

- (void)customize
{
    
}

@end

@implementation UIView (CornerMaskLayer)

- (CGFloat)cornerRadius
{
    return [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue];
}
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}


- (CGFloat)borderWidth
{
    return [objc_getAssociatedObject(self, @selector(borderWidth)) floatValue];
}
- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}


- (UIColor *)borderColor
{
    return objc_getAssociatedObject(self, @selector(borderColor));
}
- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)shadowColor
{
    return objc_getAssociatedObject(self, @selector(shadowColor));
}
- (void)setShadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}

- (CGFloat)shadowOpacity
{
    return [objc_getAssociatedObject(self, @selector(shadowOpacity)) floatValue];
}
- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = shadowOpacity;
}

@end

@implementation UIView (Optimize)
- (void)optimize
{
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.drawsAsynchronously = YES;
}
@end
