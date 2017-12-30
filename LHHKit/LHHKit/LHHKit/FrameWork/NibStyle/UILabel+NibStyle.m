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



#import "UILabel+NibStyle.h"

@implementation UILabel (NibStyle)

@dynamic nibTextColor;
@dynamic nibAdjusts;
@dynamic nibColor;

- (void)setNibTextColor:(NSString *)nibTextColor
{
    self.textColor = [UIColor colorWithHexString:nibTextColor];;
}

- (void)setNibColor:(NSString *)nibColor
{
	[self setNibTextColor:nibColor];
}

- (void)setNibAdjusts:(NSNumber *)nibAdjusts
{
	self.adjustsFontSizeToFitWidth = nibAdjusts.intValue;
}

@end
