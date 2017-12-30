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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)randomColor;

+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)colorWithHexString: (NSString *)stringToConvert alpha:(CGFloat)alpha;

+ (UIImage*)createImageWithColor:(UIColor *)color withRect:(CGRect)rect;

/**
 *  Return a UIColor from a RGBA int
 *
 *   value The int value
 */
+ (UIColor *)colorWithRGBAValue:(uint)value;

/**
 *  Return a UIColor from a ARGB int
 *
 *   value The int value
 */
+ (UIColor *)colorWithARGBValue:(uint)value;

/**
 *  Return a UIColor from a RGB int
 *
 *   value The int value
 */
+ (UIColor *)colorWithRGBValue:(uint)value;

- (UIImage *)getImageWithSize:(CGSize)aSize;

@end
