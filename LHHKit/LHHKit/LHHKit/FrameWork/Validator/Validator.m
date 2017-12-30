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

#import "Validator.h"

@implementation Validator

+ (BOOL) isEmpty:(NSString *) string
{
    if (!string)
    {
        return YES;
    }
    else
    {
        NSCharacterSet * set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString * trimedString = [string stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

+ (BOOL)isInt:(NSString *)string
{
    NSString * MOBILE = @"[-+]?[0-9]*";
    NSPredicate * regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return  [regextestMobile evaluateWithObject:string];
}

+ (BOOL)isPhoneNumber:(NSString *)string
{
	NSString * MOBILE = @"^[1-9]\\d{10}$";
	NSPredicate * regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
	return  [regextestMobile evaluateWithObject:string];
}

//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum])
        || ([regextestcm evaluateWithObject:mobileNum])
        || ([regextestct evaluateWithObject:mobileNum])
        || ([regextestcu evaluateWithObject:mobileNum]))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isUserName:(NSString *)string
{
	NSString * regex = @"(^[A-Za-z0-9]{3,25}$)";
	NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:string];
}

+ (BOOL)isPassword:(NSString *)string
{
	NSString * regex = @"(^[A-Za-z0-9]{6,20}$)";
	NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:string];
}

+ (BOOL)isPasswordChar:(NSString *)string
{
    if ([Validator isEmpty:string])
    {
        return NO;
    }
    if ( string.length > 20 )
    {
        return NO;
    }
    if ( string.length < 6 )
    {
        return NO;
    }
    return YES;
}

+ (BOOL)isVerifyCode:(NSString *)string
{
	NSString * regex = @"(^[A-Za-z0-9]{6,}$)";
	NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:string];
}

+ (BOOL)isMixedCryptogram:(NSString *)string
{
	NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,10000}$";
	NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:string];
}

+ (BOOL)isNumAndLetter:(NSString *)string
{
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{1,10000}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:string];
}

+ (BOOL)isNumOrLetter:(NSString *)string
{
    NSString * regex = @"(^[A-Za-z0-9]{1,10000}$)";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:string];
}

+ (BOOL)isNum:(NSString *)string
{
	NSString * regex = @"^[0-9]*$";
	NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:string];
}

+ (BOOL)isDecimal:(NSString *)decimal;
{
    NSString *phoneRegex = @"^[0-9]+(\\.[0-9]{1,20})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:decimal];
}

+ (BOOL)isAbc:(NSString *)string
{
	NSString * regex = @"^[a-zA-Z]*$";
	NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

	return [pred evaluateWithObject:string];
}

+ (BOOL)isEmail:(NSString *)string
{
	NSString * regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

	return [pred evaluateWithObject:string];
}

+ (BOOL)isChineseCharacterOrAbc:(NSString *)string
{
    NSString * regex = @"^[\u4E00-\u9FA5-a-zA-Z]*$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:string];
}

+ (BOOL)isChineseCharacter:(NSString *)string
{
    NSString * regex = @"^[\u4E00-\u9FA5]*$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:string];
}

+ (BOOL)isPunctuationMark:(NSString *)string
{
    if ([Validator isNumAndLetter:string])
    {
        return NO;
    }
    if ([Validator isChineseCharacter:string])
    {    
        return NO;
    }
    return YES;
}

+ (BOOL) isQQ:(NSString *)QQ
{
    
    NSString * phoneRegex = @"[1-9][0-9]{4,}";
    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:QQ];
    
}

+ (BOOL) isURL:(NSString *)URL
{
    NSString * URLRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSPredicate * URLPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", URLRegex];
    
    return [URLPredicate evaluateWithObject:URL];
}

+ (BOOL)isIdCard:(NSString *)idCard
{
    NSString * pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

@end
