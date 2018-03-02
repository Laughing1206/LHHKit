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

typedef NS_ENUM(NSUInteger, DATE_TYPE) {
    DATE_TYPE_YMDHMSW = 0,
    DATE_TYPE_YMDHMS = 1,
    DATE_TYPE_YMDHM = 2,
    DATE_TYPE_YMD = 3,
    DATE_TYPE_YM = 4,
    DATE_TYPE_MD = 5,
    DATE_TYPE_HMS = 6,
    DATE_TYPE_HM = 7,
    DATE_TYPE_MS = 8,
};

@interface NSString (Extension)

@property (nonatomic, readonly) NSString * MD5String;
@property (nonatomic, readonly) NSData * MD5Data;

@property (nonatomic, readonly) NSString * SHA1String;
@property (nonatomic, readonly) NSData * SHA1Data;

@property (nonatomic, readonly) NSString * base64EncodedString;
@property (nonatomic, readonly) NSString * base64DecodedString;
@property (nonatomic, readonly) NSData * BASE64Decrypted;

- (NSArray *)allURLs;

- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding;
- (NSString *)urlByAppendingArray:(NSArray *)params;
- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding;
- (NSString *)urlByAppendingKeyValues:(id)first, ...;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict;
+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromArray:(NSArray *)array;
+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromKeyValues:(id)first, ...;

- (NSString *)URLEncoding;
- (NSString *)URLDecoding;

- (NSString *)trim;
- (NSString *)unwrap;
- (NSString *)normalize;
- (NSString *)repeat:(NSUInteger)count;

- (BOOL)match:(NSString *)expression;
- (BOOL)matchAnyOf:(NSArray *)array;

- (BOOL)empty;
- (BOOL)notEmpty;

- (BOOL)eq:(NSString *)other;
- (BOOL)equal:(NSString *)other;

- (BOOL)is:(NSString *)other;
- (BOOL)isNot:(NSString *)other;

- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

- (BOOL)isNumber;
- (BOOL)isNumberWithPunctuation;
- (BOOL)isNumberWithUnit:(NSString *)unit;
- (BOOL)isEmail;
- (BOOL)isUrl;
- (BOOL)isIPAddress;

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string;
- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string endOffset:(NSUInteger *)endOffset;

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset;
- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset;

- (NSArray *)pairSeparatedByString:(NSString *)separator;

- (NSDictionary *)dictionaryWithJsonString;

- (NSString *)stringWithNum:(NSString *)string;

- (CGFloat)heightWithWidth:(CGFloat)width font:(id)font;

- (CGFloat)widthWithheight:(CGFloat)height font:(id)font;

- (NSInteger)multipleNameLength;

- (NSString *)removeBlankSpace;

- (NSString *)removeBlankSpaceBeforeAndAfter;

- (BOOL)containSubString:(NSString *)subString;

/**
 16进制转UIColor
 */
- (UIColor *)colorFromHexString;

/**
 时间戳转字符串
 */
+ (NSString *)getStringWithFormatter:(NSString *)str;
+ (NSString *)getStringWithType:(DATE_TYPE)type formatter:(NSString *)str;
+ (NSString *)getTimeStringWithType:(DATE_TYPE)type date:(NSDate *)date;
+ (NSString *)getYearWithDate:(NSDate *)date;
+ (NSString *)getMonthWithDate:(NSDate *)date;
+ (NSString *)getDayWithDate:(NSDate *)date;
+ (NSString *)getHourWithDate:(NSDate *)date;
+ (NSString *)getMiniteWithDate:(NSDate *)date;
+ (NSString *)getSecondWithDate:(NSDate *)date;
+ (NSString *)getWeekdayWithDate:(NSDate *)date;
+ (NSString *)getWeekOfMonthWithDate:(NSDate *)date;
+ (NSString *)getWeekOfYearWithDate:(NSDate *)date;
+ (NSDateComponents *)getDateComponentsWithDate:(NSDate *)date;

- (BOOL)isEqualWithDate:(NSString *)date;

//是否今天
+ (BOOL)isTodayWithFormatter:(NSString *)str;

- (NSString *)strToamount;

- (BOOL)isNoEmpty;

- (NSString *)APPImgURL;

@end
