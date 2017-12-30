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



#import "UIView+NibStyle.h"
#import <objc/runtime.h>

@implementation UIBorderView
@end

static const void * kStyleClasskey;
static const void * kStyleClasseskey;
static const void * kStyleIdkey;

static id<UIStyler> globalStyler;

@implementation UIView (NibStyle)

@dynamic nibBackgroundColor;
@dynamic nibBorderColor, nibBorderWidth,nibOnePixelBorder;
@dynamic nibCornerRadius;
@dynamic nibAlpha;
@dynamic nibBorder;
@dynamic nibCornerAutoRadius;
@dynamic styleId, styleClass;
@dynamic topBorder,leftBorder,rightBorder,bottomBorder;

+ (void)setGlobalStyler:(id<UIStyler>)styler
{
	globalStyler = styler;
}

- (void)setNibBackgroundColor:(NSString *)nibBackgroundColor
{
	self.backgroundColor = [UIColor colorWithHexString:nibBackgroundColor];
}

- (void)setNibBorderWidth:(NSNumber *)nibBorderWidth
{
	self.layer.borderWidth = nibBorderWidth.floatValue;
}

- (void)setNibOnePixelBorder:(BOOL)nibOnePixelBorder
{
	self.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
}


+ (UIColor *)colorWithAny:(id)any
{
	if ( [any isKindOfClass:[NSString class]] ) {
		return [UIColor colorWithHexString:any];
	} else if ( [any isKindOfClass:[UIColor class]] ) {
		return (UIColor *)any;
	} else {
		return nil;
	}
}

- (void)setNibBorderColor:(id)nibBorderColor
{
	UIColor * color = [UIView colorWithAny:nibBorderColor];
	if ( color ) {
		self.layer.borderColor = color.CGColor;
	}
}

- (void)setNibCornerRadius:(NSNumber *)nibCornerRadius
{
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = nibCornerRadius.floatValue;
}

- (void)setNibCornerAutoRadius:(NSString *)nibCornerAutoRadius
{
	NSArray * arrays = [nibCornerAutoRadius componentsSeparatedByString:@" "];

	int radius = 0;

	NSString * topLeft = arrays[0];
	NSString * topRight = arrays[1];
	NSString * bottomLeft = arrays[2];
	NSString * bottomRight = arrays[3];

	UIRectCorner opt = 0x00;

	if ( topLeft.intValue ) {
		radius = topLeft.intValue;
		opt |= UIRectCornerTopLeft;
	}
	
	if ( topRight.intValue ) {
		radius = topRight.intValue;
		opt |= UIRectCornerTopRight;
	}
	
	if ( bottomLeft.intValue ) {
		radius = bottomLeft.intValue;
		opt |= UIRectCornerBottomLeft;
	}
	
	if ( bottomRight.intValue ) {
		radius = bottomRight.intValue;
		opt |= UIRectCornerBottomRight;
	}
	
	UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:opt cornerRadii:CGSizeMake(radius, radius)];
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	maskLayer.frame = self.bounds;
	maskLayer.path = maskPath.CGPath;
	self.layer.mask = maskLayer;
}

- (void)setNibBorder:(NSString *)nibBorder
{
	NSArray * arrays = [nibBorder componentsSeparatedByString:@" "];

	if ( arrays.count < 6 )
		return;

	NSString * top = arrays[0];
	NSString * left = arrays[1];
	NSString * bottom = arrays[2];
	NSString * right = arrays[3];
	NSString * isIn = arrays[4];
	NSString * colorStr = arrays[5];

	float height = self.frame.size.height;
	float width = self.frame.size.width;

	if ( width < [UIApplication sharedApplication].delegate.window.rootViewController.view.width )
	{
		width = [UIApplication sharedApplication].delegate.window.rootViewController.view.width;
	}

	CGRect frame = CGRectZero;

// top

	if ( isIn.intValue )
	{
		frame = CGRectMake(0, 0, width, top.floatValue);
	}
	else
	{
		frame = CGRectMake(0, -top.intValue, width, top.floatValue);
	}
	
	[self setborderWithFrame:frame colorStr:colorStr index:1];

// left

	if ( isIn.floatValue )
	{
		frame = CGRectMake(0, 0, left.floatValue, height);
	}
	else
	{
		frame = CGRectMake(-left.intValue, 0, left.floatValue, height);
	}

	[self setborderWithFrame:frame colorStr:colorStr index:2];

//	bottom
	
	if ( isIn.floatValue )
	{
		frame = CGRectMake(0, height - bottom.floatValue, width, bottom.floatValue);
	}
	else
	{
		frame = CGRectMake(0, height, width, bottom.floatValue);
	}

	[self setborderWithFrame:frame colorStr:colorStr index:3];

//	right
	
	if ( isIn.floatValue )
	{
		frame = CGRectMake(width - right.floatValue, 0, right.floatValue, height);
	}
	else
	{
		frame = CGRectMake(width, 0, right.floatValue, height);
	}
	
	[self setborderWithFrame:frame colorStr:colorStr index:4];
}

- (void)setborderWithFrame:(CGRect)frame colorStr:(NSString *)colorStr index:(NSInteger)index
{
	switch ( index ) {
		case 1:
		{
			if ( nil == self.topBorder )
			{
				self.topBorder = [[UIBorderView alloc] initWithFrame:frame];
				self.topBorder.layer.masksToBounds = YES;
				self.topBorder.backgroundColor = [UIView colorWithAny:colorStr];
				[self addSubview:self.topBorder];
			}

			self.topBorder.frame = frame;
		}
			break;
		case 2:
		{
			if ( nil == self.leftBorder )
			{
				self.leftBorder = [[UIBorderView alloc] initWithFrame:frame];
				self.leftBorder.layer.masksToBounds = YES;
				self.leftBorder.backgroundColor = [UIView colorWithAny:colorStr];
				[self addSubview:self.leftBorder];
			}
			self.leftBorder.frame = frame;
		}
			break;
		case 3:
		{
			if ( nil == self.bottomBorder )
			{
				self.bottomBorder = [[UIBorderView alloc] initWithFrame:frame];
				self.bottomBorder.layer.masksToBounds = YES;
				self.bottomBorder.backgroundColor = [UIView colorWithAny:colorStr];
				[self addSubview:self.bottomBorder];
			}

			self.bottomBorder.frame = frame;
		}
			break;
		case 4:
		{
			if ( nil == self.rightBorder )
			{
				self.rightBorder = [[UIBorderView alloc] initWithFrame:frame];
				self.rightBorder.layer.masksToBounds = YES;
				self.rightBorder.backgroundColor = [UIView colorWithAny:colorStr];
				[self addSubview:self.rightBorder];
			}
			self.rightBorder.frame = frame;
		}
			break;
		default:
			break;
	}
}

- (void)setNibAlpha:(NSNumber *)nibAlpha
{
	self.alpha = nibAlpha.floatValue;
}

#pragma mark -

- (NSString *)styleClass
{
	return objc_getAssociatedObject(self, kStyleClasskey);
}

- (NSString *)styleId
{
	NSString *id = objc_getAssociatedObject(self, kStyleIdkey);
	return id;
}

- (void)setStyleClass:(NSString *)aClass
{
	// make sure we have a string - needed to filter bad input from IB
	aClass = [aClass description];
	
	// trim leading and trailing whitespace
	aClass = [aClass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	objc_setAssociatedObject(self, kStyleClasskey, aClass, OBJC_ASSOCIATION_COPY_NONATOMIC);
	
	//Precalculate classes array for performance gain
	NSArray *classes = [aClass componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	classes = [classes sortedArrayUsingComparator:^NSComparisonResult(NSString *class1, NSString *class2) {
		return [class1 compare:class2];
	}];
	objc_setAssociatedObject(self, kStyleClasseskey, classes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setStyleId:(NSString *)anId
{
	// make sure we have a string - needed to filter bad input from IB
	anId = [anId description];
	
	// trim leading and trailing whitespace
	anId = [anId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	objc_setAssociatedObject(self, kStyleIdkey, anId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
