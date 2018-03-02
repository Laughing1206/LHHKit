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

@interface Validator : NSObject

/**
 *  判断是否为空
 */
+ (BOOL) isEmpty:(NSString *) string;
/**
 *  判断是否为整数
 */
+ (BOOL)isInt:(NSString *)string;

/**
 *  11位数字
 **/
+ (BOOL)isPhoneNumber:(NSString *)string;

/**
 *  手机号
 **/
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  长度大于2
 **/
+ (BOOL)isUserName:(NSString *)string;

/**
 *  6-20 字母数字
 **/
+ (BOOL)isPassword:(NSString *)string;

/**
 *  6-20 字符
 **/
+ (BOOL)isPasswordChar:(NSString *)string;

/**
 *  验证码
 **/
+ (BOOL)isVerifyCode:(NSString *)string;

/**
 *  是否是组合密码
 **/
+ (BOOL)isMixedCryptogram:(NSString *)string;

/**
 *  是否是数字和字母
 **/
+ (BOOL)isNumAndLetter:(NSString *)string;

/**
 *  是否是数字或字母
 **/
+ (BOOL)isNumOrLetter:(NSString *)string;

/**
 *  是否是数字
 **/
+ (BOOL)isNum:(NSString *)string;

/**
 *  是否是小数
 **/
+ (BOOL)isDecimal:(NSString *)decimal;

/**
 *  是否是字母
 **/
+ (BOOL)isAbc:(NSString *)string;

/**
 *  判断是否是邮箱
 */
+ (BOOL)isEmail:(NSString *)string;

/**
 *  判断是否是汉字
 */
+ (BOOL)isChineseCharacter:(NSString *)string;

/**
 *  判断是否是汉字或字母
 */
+ (BOOL)isChineseCharacterOrAbc:(NSString *)string;

/**
 *  判断是否是标点符号
 */
+ (BOOL)isPunctuationMark:(NSString *)string;
/**
 *  判断是否是QQ
 */
+ (BOOL) isQQ:(NSString *)QQ;

/**
 *  判断是否是网址
 */
+ (BOOL) isURL:(NSString *)URL;

/**
 *  判断是否是身份证号
 */
+ (BOOL)isIdCard:(NSString *)idCard;

/**
 *  判断是否是视频
 */
+ (BOOL) isVideo:(NSString *)URL;
@end
