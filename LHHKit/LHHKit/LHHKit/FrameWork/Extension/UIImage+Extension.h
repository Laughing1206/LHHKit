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

@interface UIImage (Extension)

- (UIImage *)scaleToSize:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)fixedLibraryImageToSize:(CGSize)size;
- (UIImage *)fixedCameraImageToSize:(CGSize)size;

- (void)fixedCameraImageToSize:(CGSize)size then:(void (^)(NSData *))then;

- (UIImage *)fixOrientation;

- (instancetype)circleImage;
+ (instancetype)circleImage:(NSString *)name;
@end
