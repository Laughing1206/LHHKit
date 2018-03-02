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



#import "NSLayoutConstraint+NibStyle.h"

@implementation NSLayoutConstraint (NibStyle)

@dynamic nibConstant;

- (void)setNibConstant:(CGFloat)nibConstant
{
	self.constant = nibConstant;
}

- (CGFloat)nibConstant
{
	return self.constant;
}

- (void)setNibOnePixel:(BOOL)nibOnePixel
{
	self.constant = 1 / [UIScreen mainScreen].scale;
}

- (BOOL)nibOnePixel
{
	return YES;
}

@end
