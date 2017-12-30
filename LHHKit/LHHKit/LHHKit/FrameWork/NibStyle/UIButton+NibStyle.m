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



#import "UIButton+NibStyle.h"

@implementation UIButton (NibStyle)

@dynamic nibTextColor;
@dynamic nibNormalTextColor;
@dynamic nibSelectedTextColor;
@dynamic nibHighlightedTextColor;
@dynamic nibDisabledTextColor;

- (void)setNibTintColor:(NSString *)tintColor
{
    [self setTintColor:[UIColor colorWithHexString:tintColor]];
}

- (void)setNibTextColor:(NSString *)nibTextColor
{
	[self setNibNormalTextColor:nibTextColor];
}

- (void)setNibNormalTextColor:(NSString *)nibNormalTextColor
{
    [self setTitleColor:[UIColor colorWithHexString:nibNormalTextColor] forState:UIControlStateNormal];
}

- (void)setNibSelectedTextColor:(NSString *)nibSelectedTextColor
{
    [self setTitleColor:[UIColor colorWithHexString:nibSelectedTextColor] forState:UIControlStateSelected];
}

- (void)setNibHighlightedTextColor:(NSString *)nibHighlightedTextColor
{
    [self setTitleColor:[UIColor colorWithHexString:nibHighlightedTextColor] forState:UIControlStateHighlighted];
}

- (void)setNibDisabledTextColor:(NSString *)nibDisabledTextColor
{
    [self setTitleColor:[UIColor colorWithHexString:nibDisabledTextColor] forState:UIControlStateDisabled];
}

@end
