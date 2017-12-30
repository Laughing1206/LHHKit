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

/**
 *  定义各个页面所用到的字体及颜色 以及段落样式
 */
@interface AppTheme : NSObject

SingletonInterface( AppTheme )

+ (void)setupAppearanceWithViewController:(UITabBarController *)vc;

#pragma mark - 

+ (NSDictionary *)styleClass;

#pragma mark -

+ (UIColor *)mainColor;
+ (UIColor *)titleColor;
+ (UIColor *)subTitleColor;
+ (UIColor *)mainBackgroundColor;
+ (UIColor *)lineColor;
+ (UIFont *)cn14SizeRegularFont;

#pragma mark - Placeholder

+ (void)setPlaceholderImage:(UIImage *)image;
+ (UIImageView *)placeholderView;
+ (UITableViewCell *)placeholderTableViewCell;
+ (UICollectionViewCell *)placeholderCollectionViewCell;

+ (NSAttributedString *)attributedPlaceholderWithString:(NSString *)string;

#pragma mark - Line

+ (CGFloat)onePixel;
+ (void)onePixelizes:(NSArray *)constraints;

#pragma mark - Pad

+ (CGSize)preferredContentSize;

#pragma mark - UITabBarItem

+ (UITabBarItem *)itemWithImage:(UIImage *)image selectImage:(UIImage *)selectImage title:(NSString *)title;
+ (UITabBarItem *)itemWithImageName:(NSString *)imageName selectImageName:(NSString *)selectImageName title:(NSString *)title;

#pragma mark - UINavigationBarItem

+ (UIBarButtonItem *)itemWithContent:(id)content handler:(void (^)(id sender))handler;

+ (UIBarButtonItem *)backItemWithHandler:(void (^)(id sender))handler;
+ (UIBarButtonItem *)backModalWithHandler:(void (^)(id sender))handler;
+ (UIBarButtonItem *)shareItemWithHandler:(void (^)(id sender))handler;
+ (UIBarButtonItem *)setupItemWithHandler:(void (^)(id sender))handler;
+ (UIBarButtonItem *)editItemWithTitle:(NSString *)title Handler:(void (^)(id sender))handler;
+ (UIBarButtonItem *)whiteItemWithTitle:(NSString *)title Handler:(void (^)(id sender))handler;
+ (UIBarButtonItem *)loginItemWithTitle:(NSString *)title Handler:(void (^)(id sender))handler;

#pragma mark - LableFrame

+ (CGRect)estimateTitleLableFrameWithString:(NSString *)title
                                       size:(CGSize)size;

+ (NSAttributedString *)getTitleAttributedString:(NSString *)str;
+ (UIFont *)detailTitleFont;
+ (UIFont *)orderResultTextFont;
+ (UIFont *)productListTextFont;
+ (NSMutableParagraphStyle *)detailParagraphStyle;

#pragma mark - Placeholder

+ (UIImage *)placeholderImage;
+ (UIImage *)buildingPlaceholderImage;

#pragma mark - PriceString

+ (NSString *)priceWithString:(NSString *)string;

+ (void)presentViewController:(UIViewController *)controller inViewController:(UIViewController *)container;

+ (void)adaptToiPad;

+ (NSMutableAttributedString *)countdownAttributedString:(NSString *)str;

/**
 字符串加星处理
 
 @param content NSString字符串
 @param findex 第几位开始加星
 @return 返回加星后的字符串
 */
+ (NSString *)encryptionDisplayMessageWith:(NSString *)content WithFirstIndex:(NSInteger)findex;


/**
 字符串转成富文本
 
 @param string 字符串
 @param startRanges 开始字符位数
 @param endRanges 结束字符位数
 @param fonts 字号
 @param colors 颜色
 @param baselineOffsets 基准
 @return 富文本
 */
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string
                                              startRanges:(NSArray *)startRanges
                                                endRanges:(NSArray *)endRanges
                                                    fonts:(NSArray *)fonts
                                                   colors:(NSArray *)colors
                                          baselineOffsets:(NSArray *)baselineOffsets;

#pragma mark - 图片转base64编码
+ (NSString *)UIImageToBase64Str:(UIImage *) image;

#pragma mark - base64图片转编码
+ (UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr;

+ (void)telWithPhone:(NSString *)phoneNumber on:(UIViewController *)owner;
@end
