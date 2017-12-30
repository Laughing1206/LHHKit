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



#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)MD5String
{
    return [[NSData dataWithBytes:[self UTF8String] length:[self length]] MD5String];
}

- (NSData *)MD5Data
{
    return [[NSData dataWithBytes:[self UTF8String] length:[self length]] MD5Data];
}

- (NSString *)SHA1String
{
    return [[NSData dataWithBytes:[self UTF8String] length:[self length]] SHA1String];
}

- (NSData *)SHA1Data
{
    return [[NSData dataWithBytes:[self UTF8String] length:[self length]] SHA1Data];
}

- (NSData *)BASE64Decrypted
{
    static char * __base64EncodingTable = (char *)"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    static char * __base64DecodingTable = nil;
    
    // copy from THREE20
    
    if ( 0 == [self length] )
    {
        return [NSData data];
    }
    
    if ( NULL == __base64DecodingTable )
    {
        __base64DecodingTable = (char *)malloc( 256 );
        if ( NULL == __base64DecodingTable )
        {
            return nil;
        }
        
        memset( __base64DecodingTable, CHAR_MAX, 256 );
        
        for ( int i = 0; i < 64; i++)
        {
            __base64DecodingTable[(short)__base64EncodingTable[i]] = (char)i;
        }
    }
    
    const char * characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
    if ( NULL == characters )     //  Not an ASCII string!
    {
        return nil;
    }
    
    char * bytes = (char *)malloc( ([self length] + 3) * 3 / 4 );
    if ( NULL == bytes )
    {
        return nil;
    }
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    
    while ( 1 )
    {
        char    buffer[4] = { 0 };
        short    bufferLength = 0;
        
        for ( bufferLength = 0; bufferLength < 4; i++ )
        {
            if ( characters[i] == '\0' )
            {
                break;
            }
            
            if ( isspace(characters[i]) || characters[i] == '=' )
            {
                continue;
            }
            
            buffer[bufferLength] = __base64DecodingTable[(short)characters[i]];
            if ( CHAR_MAX == buffer[bufferLength++] )
            {
                free(bytes);
                return nil;
            }
        }
        
        if ( 0 == bufferLength )
        {
            break;
        }
        
        if ( 1 == bufferLength )
        {
            // At least two characters are needed to produce one byte!
            
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        
        bytes[length++] = (char)((buffer[0] << 2) | (buffer[1] >> 4));
        
        if (bufferLength > 2)
        {
            bytes[length++] = (char)((buffer[1] << 4) | (buffer[2] >> 2));
        }
        
        if (bufferLength > 3)
        {
            bytes[length++] = (char)((buffer[2] << 6) | buffer[3]);
        }
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-result"
    realloc( bytes, length );
#pragma clang diagnostic pop
    
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSArray *)allURLs
{
    NSMutableArray * array = [NSMutableArray array];
    NSCharacterSet * charSet = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_.+!*'():/"] invertedSet];
    
    for ( NSUInteger stringIndex = 0; stringIndex < self.length; )
    {
        NSRange searchRange = NSMakeRange(stringIndex, self.length - stringIndex);
        NSRange httpRange = [self rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:searchRange];
        NSRange httpsRange = [self rangeOfString:@"https://" options:NSCaseInsensitiveSearch range:searchRange];
        
        NSRange startRange;
        if ( httpRange.location == NSNotFound )
        {
            startRange = httpsRange;
        }
        else if ( httpsRange.location == NSNotFound )
        {
            startRange = httpRange;
        }
        else
        {
            startRange = (httpRange.location < httpsRange.location) ? httpRange : httpsRange;
        }
        
        if (startRange.location == NSNotFound)
        {
            break;
        }
        else
        {
            NSRange beforeRange = NSMakeRange( searchRange.location, startRange.location - searchRange.location );
            if ( beforeRange.length )
            {
                //                NSString * text = [string substringWithRange:beforeRange];
                //                [array addObject:text];
            }
            
            NSRange subSearchRange = NSMakeRange(startRange.location, self.length - startRange.location);
            //            NSRange endRange = [self rangeOfString:@" " options:NSCaseInsensitiveSearch range:subSearchRange];
            NSRange endRange = [self rangeOfCharacterFromSet:charSet options:NSCaseInsensitiveSearch range:subSearchRange];
            if ( endRange.location == NSNotFound)
            {
                NSString * url = [self substringWithRange:subSearchRange];
                [array addObject:url];
                break;
            }
            else
            {
                NSRange URLRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
                NSString * url = [self substringWithRange:URLRange];
                [array addObject:url];
                
                stringIndex = endRange.location;
            }
        }
    }
    
    return array;
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict
{
    return [self queryStringFromDictionary:dict encoding:YES];
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding
{
    NSMutableArray * pairs = [NSMutableArray array];
    for ( NSString * key in dict.allKeys )
    {
        NSString * value = [((NSObject *)[dict objectForKey:key]) toString];
        NSString * urlEncoding = encoding ? [value URLEncoding] : value;
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromArray:(NSArray *)array
{
    return [self queryStringFromArray:array encoding:YES];
}

+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding
{
    NSMutableArray *pairs = [NSMutableArray array];
    
    for ( NSUInteger i = 0; i < [array count]; i += 2 )
    {
        NSObject * obj1 = [array objectAtIndex:i];
        NSObject * obj2 = [array objectAtIndex:i + 1];
        
        NSString * key = nil;
        NSString * value = nil;
        
        if ( [obj1 isKindOfClass:[NSNumber class]] )
        {
            key = [(NSNumber *)obj1 stringValue];
        }
        else if ( [obj1 isKindOfClass:[NSString class]] )
        {
            key = (NSString *)obj1;
        }
        else
        {
            continue;
        }
        
        if ( [obj2 isKindOfClass:[NSNumber class]] )
        {
            value = [(NSNumber *)obj2 stringValue];
        }
        else if ( [obj1 isKindOfClass:[NSString class]] )
        {
            value = (NSString *)obj2;
        }
        else
        {
            continue;
        }
        
        NSString * urlEncoding = encoding ? [value URLEncoding] : value;
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromKeyValues:(id)first, ...
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    va_list args;
    va_start( args, first );
    
    for ( ;; )
    {
        NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
        if ( nil == key )
            break;
        
        NSObject * value = va_arg( args, NSObject * );
        if ( nil == value )
            break;
        
        [dict setObject:value forKey:key];
    }
    va_end( args );
    return [NSString queryStringFromDictionary:dict];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params
{
    return [self urlByAppendingDict:params encoding:YES];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
    NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString * query = [NSString queryStringFromDictionary:params encoding:encoding];
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)urlByAppendingArray:(NSArray *)params
{
    return [self urlByAppendingArray:params encoding:YES];
}

- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
    NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString * query = [NSString queryStringFromArray:params encoding:encoding];
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)urlByAppendingKeyValues:(id)first, ...
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    va_list args;
    va_start( args, first );
    
    for ( ;; )
    {
        NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
        if ( nil == key )
            break;
        
        NSObject * value = va_arg( args, NSObject * );
        if ( nil == value )
            break;
        
        [dict setObject:value forKey:key];
    }
    va_end( args );
    return [self urlByAppendingDict:dict];
}

- (NSString *)URLEncoding
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return (__bridge_transfer NSString *)
    CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
#pragma clang diagnostic pop
}

- (NSString *)URLDecoding
{
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"../"
                            withString:@""
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)unwrap
{
    if ( self.length >= 2 )
    {
        if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
        
        if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
    }
    
    return self;
}

- (NSString *)normalize
{
    //    return [self stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    //    return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSArray * lines = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if ( lines && lines.count )
    {
        NSMutableString * mergedString = [NSMutableString string];
        
        for ( NSString * line in lines )
        {
            NSString * trimed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ( trimed && trimed.length )
            {
                [mergedString appendString:trimed];
            }
        }
        
        return mergedString;
    }
    
    return nil;
}

- (NSString *)repeat:(NSUInteger)count
{
    if ( 0 == count )
        return @"";
    
    NSMutableString * text = [NSMutableString string];
    
    for ( NSUInteger i = 0; i < count; ++i )
    {
        [text appendString:self];
    }
    
    return text;
}

- (NSString *)strongify
{
    return [self stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
}

- (BOOL)match:(NSString *)expression
{
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    if ( nil == regex )
        return NO;
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
                                                        options:0
                                                          range:NSMakeRange(0, self.length)];
    if ( 0 == numberOfMatches )
        return NO;
    
    return YES;
}

- (BOOL)matchAnyOf:(NSArray *)array
{
    for ( NSString * str in array )
    {
        if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] )
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)empty
{
    return [self length] > 0 ? NO : YES;
}

- (BOOL)notEmpty
{
    return [self length] > 0 ? YES : NO;
}

- (BOOL)eq:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)equal:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)is:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)isNot:(NSString *)other
{
    return NO == [self isEqualToString:other];
}

- (BOOL)isValueOf:(NSArray *)array
{
    return [self isValueOf:array caseInsens:NO];
}

- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens
{
    NSStringCompareOptions option = caseInsens ? NSCaseInsensitiveSearch : 0;
    
    for ( NSObject * obj in array )
    {
        if ( NO == [obj isKindOfClass:[NSString class]] )
            continue;
        
        if ( NSOrderedSame == [(NSString *)obj compare:self options:option] )
            return YES;
    }
    
    return NO;
}

- (BOOL)isNumber
{
    NSString *        regex = @"[0-9]+";
    NSPredicate *    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isNumberWithPunctuation
{
    NSString *        regex = @"-?[0-9.]+";
    NSPredicate *    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isNumberWithUnit:(NSString *)unit
{
    NSString *        regex = [NSString stringWithFormat:@"-?[0-9.]+%@", unit];
    NSPredicate *    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *        regex = @"[A-Z0-9a-z._\%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSPredicate *    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:[self lowercaseString]];
}

- (BOOL)isUrl
{
    return ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) ? YES : NO;
}

- (BOOL)isIPAddress
{
    NSArray * components = [self componentsSeparatedByString:@"."];
    NSCharacterSet * invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    
    if ( [components count] == 4 )
    {
        NSString *part1 = [components objectAtIndex:0];
        NSString *part2 = [components objectAtIndex:1];
        NSString *part3 = [components objectAtIndex:2];
        NSString *part4 = [components objectAtIndex:3];
        
        if ( 0 == [part1 length] ||
            0 == [part2 length] ||
            0 == [part3 length] ||
            0 == [part4 length] )
        {
            return NO;
        }
        
        if ( [part1 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part2 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part3 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part4 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound )
        {
            if ( [part1 intValue] <= 255 &&
                [part2 intValue] <= 255 &&
                [part3 intValue] <= 255 &&
                [part4 intValue] <= 255 )
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string
{
    return [self substringFromIndex:from untilString:string endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string endOffset:(NSUInteger *)endOffset
{
    if ( 0 == self.length )
        return nil;
    
    if ( from >= self.length )
        return nil;
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfString:string options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        if ( endOffset )
        {
            *endOffset = range.location + range.length;
        }
        
        return [self substringWithRange:range];
    }
    else
    {
        if ( endOffset )
        {
            *endOffset = range2.location + range2.length;
        }
        
        return [self substringWithRange:NSMakeRange(from, range2.location - from)];
    }
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset
{
    return [self substringFromIndex:from untilCharset:charset endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset
{
    if ( 0 == self.length )
        return nil;
    
    if ( from >= self.length )
        return nil;
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfCharacterFromSet:charset options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        if ( endOffset )
        {
            *endOffset = range.location + range.length;
        }
        
        return [self substringWithRange:range];
    }
    else
    {
        if ( endOffset )
        {
            *endOffset = range2.location + range2.length;
        }
        
        return [self substringWithRange:NSMakeRange(from, range2.location - from)];
    }
}

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset
{
    if ( 0 == self.length )
        return 0;
    
    if ( from >= self.length )
        return 0;
    
    NSCharacterSet * reversedCharset = [charset invertedSet];
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfCharacterFromSet:reversedCharset options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        return self.length - from;
    }
    else
    {
        return range2.location - from;
    }
}

- (NSArray *)pairSeparatedByString:(NSString *)separator
{
    if ( nil == separator )
        return nil;
    
    NSUInteger    offset = 0;
    NSString *    key = [self substringFromIndex:0 untilCharset:[NSCharacterSet characterSetWithCharactersInString:separator] endOffset:&offset];
    NSString *    val = nil;
    
    if ( nil == key || offset >= self.length )
        return nil;
    
    val = [self substringFromIndex:offset];
    if ( nil == val )
        return nil;
    
    return [NSArray arrayWithObjects:key, val, nil];
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 *  jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString
{
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    
    return dic;
}

- (NSString *)stringWithNum:(NSString *)string
{
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc] init];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];
    [formatter setUsesGroupingSeparator:YES];
    NSNumber *num= [NSNumber numberWithInt:string.intValue];
    NSString *str = [formatter stringFromNumber:num];
    return str;
}

- (CGFloat)heightWithWidth:(CGFloat)width font:(id)font
{
    // 计算文本的大小
    
    if ( !self.length )
    {
        return 0;
    }
    UIFont * currentFont = nil;
    if ([font isKindOfClass:[UIFont class]])
    {
        currentFont = font;
    }
    else if ([font isKindOfClass:[NSString class]])
    {
        currentFont = [UIFont systemFontOfSize:[font floatValue]];
    }
    else
    {
        currentFont = [UIFont systemFontOfSize:12.f];
    }
    CGSize sizeToFit = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                       attributes:@{NSFontAttributeName:currentFont}        // 文字的属性
                                          context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height;
}

- (CGFloat)widthWithheight:(CGFloat)height font:(id)font
{
    // 计算文本的大小
    
    if ( !self.length )
    {
        return 0;
    }
    UIFont * currentFont = nil;
    if ([font isKindOfClass:[UIFont class]])
    {
        currentFont = font;
    }
    else if ([font isKindOfClass:[NSString class]])
    {
        currentFont = [UIFont systemFontOfSize:[font floatValue]];
    }
    else
    {
        currentFont = [UIFont systemFontOfSize:12.f];
    }
    CGSize sizeToFit = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) // 用于计算文本绘制时占据的矩形块
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                       attributes:@{NSFontAttributeName:currentFont}        // 文字的属性
                                          context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.width;

}

- (NSInteger)multipleNameLength
{
    NSInteger count = 0;
    
    NSRegularExpression *  iExpression;
    NSString * pattern = @"[^\u4e00-\u9fa5]+";
    iExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSRange paragaphRange = NSMakeRange(0, self.length);
    
    NSArray * matches = [iExpression matchesInString:self options:0 range:paragaphRange];
    if ( matches )
    {
        for (int i = 0; i < matches.count;i++)
        {
            NSTextCheckingResult *result = matches[i];
            count += result.range.length;
        }
    }
    
    NSRegularExpression * iExpression2;
    NSString * pattern2 = @"[\u4e00-\u9fa5]+";
    iExpression2 = [NSRegularExpression regularExpressionWithPattern:pattern2 options:0 error:NULL];
    
    NSArray * matches2 = [iExpression2 matchesInString:self options:0 range:paragaphRange];
    if ( matches2 )
    {
        for (int i = 0; i < matches2.count;i++)
        {
            NSTextCheckingResult *result = matches2[i];
            count += result.range.length;
        }
    }
    return count;
}

- (NSString *)removeBlankSpace
{
    NSString * removeBlankSpaceString = @"";
    
    removeBlankSpaceString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    removeBlankSpaceString = [removeBlankSpaceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return removeBlankSpaceString;
}

- (NSString *)removeBlankSpaceBeforeAndAfter
{
    NSString * removeBlankSpaceString = @"";
    
    removeBlankSpaceString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return removeBlankSpaceString;
}

- (BOOL)containSubString:(NSString *)subString
{
    return [self rangeOfString:subString].location != NSNotFound;
}

- (UIColor *)colorFromHexString
{
    return [UIColor colorWithHexString:self];
}

/**
 时间戳转字符串
 */
+ (NSString *)getStringWithFormatter:(NSString *)str;
{
    if (str && str.length)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyy-MM-dd HH:mm"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[str longLongValue]];
        
        return [formatter stringFromDate:confromTimesp];
    }
    return @"";
}

+ (NSString *)getTimeStringWithType:(DATE_TYPE)type date:(NSDate *)date;
{
    NSDate * currentDate = date;
    if (currentDate == nil)
    {
        currentDate = [NSDate date];
    }
    
    NSString * year = [NSString getYearWithDate:currentDate];
    NSString * month = [NSString getMonthWithDate:currentDate];
    NSString * day = [NSString getDayWithDate:currentDate];
    NSString * hour = [NSString getHourWithDate:currentDate];
    NSString * minute = [NSString getMiniteWithDate:currentDate];
    NSString * second = [NSString getSecondWithDate:currentDate];
    NSString * weekday = [NSString getWeekdayWithDate:currentDate];
    switch (type)
    {
        case DATE_TYPE_YMDHMSW:
        {
            return [NSString stringWithFormat:@"%@年%@月%@日 %@时%@分%@秒 %@",year,month,day,hour,minute,second,weekday];
        }
            break;
        case DATE_TYPE_YMDHMS:
        {
            return [NSString stringWithFormat:@"%@年%@月%@日 %@时%@分%@秒",year,month,day,hour,minute,second];
        }
            break;
        case DATE_TYPE_YMDHM:
        {
            return [NSString stringWithFormat:@"%@年%@月%@日 %@时%@分",year,month,day,hour,minute];
        }
            break;
        case DATE_TYPE_YMD:
        {
            return [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
        }
            break;
        case DATE_TYPE_YM:
        {
            return [NSString stringWithFormat:@"%@年%@月",year,month];
        }
            break;
        case DATE_TYPE_MD:
        {
            return [NSString stringWithFormat:@"%@月%@日",month,day];
        }
            break;
        case DATE_TYPE_HMS:
        {
            return [NSString stringWithFormat:@"%@时%@分%@秒",hour,minute,second];
        }
            break;
        case DATE_TYPE_HM:
        {
            return [NSString stringWithFormat:@"%@时%@分",hour,minute];
        }
            break;
        case DATE_TYPE_MS:
        {
            return [NSString stringWithFormat:@"%@分%@秒",minute,second];
        }
            break;
            
        default:
            break;
    }
}

+ (NSString *)getYearWithDate:(NSDate *)date
{
    NSDate * currentDate = date;
    if (currentDate == nil)
    {
        currentDate = [NSDate date];
    }
    
    return [NSString stringWithFormat:@"%ld",[NSString getDateComponentsWithDate:currentDate].year];
}

+ (NSString *)getMonthWithDate:(NSDate *)date
{
    NSDate * currentDate = date;
    if (currentDate == nil)
    {
        currentDate = [NSDate date];
    }
    return [NSString stringWithFormat:@"%ld",[NSString getDateComponentsWithDate:currentDate].month];
}

+ (NSString *)getDayWithDate:(NSDate *)date
{
    NSDate * currentDate = date;
    if (currentDate == nil)
    {
        currentDate = [NSDate date];
    }
    return [NSString stringWithFormat:@"%ld",[NSString getDateComponentsWithDate:currentDate].day];
}

+ (NSString *)getHourWithDate:(NSDate *)date
{
    NSDate * currentDate = date;
    if (currentDate == nil)
    {
        currentDate = [NSDate date];
    }
    return [NSString stringWithFormat:@"%ld",[NSString getDateComponentsWithDate:currentDate].hour];
}

+ (NSString *)getMiniteWithDate:(NSDate *)date
{
    NSDate * currentDate = date;
    if (currentDate == nil)
    {
        currentDate = [NSDate date];
    }
    return [NSString stringWithFormat:@"%ld",[NSString getDateComponentsWithDate:currentDate].minute];
}
+ (NSString *)getSecondWithDate:(NSDate *)date
{
    NSDate * currentDate = date;
    if (currentDate == nil)
    {
        currentDate = [NSDate date];
    }
    return [NSString stringWithFormat:@"%ld",[NSString getDateComponentsWithDate:currentDate].second];
}

+ (NSString *)getWeekdayWithDate:(NSDate *)date
{
    NSDate * currentDate = date;
    if (currentDate == nil)
    {
        currentDate = [NSDate date];
    }
    NSInteger weekday = [NSString getDateComponentsWithDate:currentDate].weekday;
    
    switch (weekday)
    {
        case 1:return @"星期日";break;
        case 2:return @"星期一";break;
        case 3:return @"星期二";break;
        case 4:return @"星期三";break;
        case 5:return @"星期四";break;
        case 6:return @"星期五";break;
        case 7:return @"星期六";break;
        default:return @"星期八";break;
    }
}

+ (NSString *)getWeekOfMonthWithDate:(NSDate *)date
{
    NSDate * currentDate = date;
    if (currentDate == nil)
    {
        currentDate = [NSDate date];
    }
    return [NSString stringWithFormat:@"%ld",[NSString getDateComponentsWithDate:currentDate].weekOfMonth];
}

+ (NSString *)getWeekOfYearWithDate:(NSDate *)date
{
    NSDate * currentDate = date;
    if (currentDate == nil)
    {
        currentDate = [NSDate date];
    }
    return [NSString stringWithFormat:@"%ld",[NSString getDateComponentsWithDate:currentDate].weekOfYear];
}

+ (NSDateComponents *)getDateComponentsWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | kCFCalendarUnitWeekOfYear;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent;
};

+ (BOOL)isTodayWithFormatter:(NSString *)str
{
    if (str && str.length)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyy-MM-dd HH:mm"];
        NSDate * confromTimesp = [NSDate dateWithTimeIntervalSince1970:[str longLongValue]];
        
        NSDate * today = [NSDate date];
        
        if ([NSString getDateComponentsWithDate:confromTimesp].year != [NSString getDateComponentsWithDate:today].year)
        {
            return NO;
        }
        if ([NSString getDateComponentsWithDate:confromTimesp].month != [NSString getDateComponentsWithDate:today].month)
        {
            return NO;
        }
        if ([NSString getDateComponentsWithDate:confromTimesp].day != [NSString getDateComponentsWithDate:today].day)
        {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (BOOL)isEqualWithDate:(NSString *)date
{
    NSDateComponents * dateComponentOne = [[self toDate] YMDHMComponents];
    NSDateComponents * dateComponentTwo = [[date toDate] YMDHMComponents];
    NSString * oneDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)dateComponentOne.year,(long)dateComponentOne.month, (long)dateComponentOne.day];
    NSString * twoDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)dateComponentTwo.year,(long)dateComponentTwo.month, (long)dateComponentTwo.day];
    
    if ( [oneDateStr isEqualToString:twoDateStr] )
    {
        return YES;
    }
    
    return NO;
}


- (NSString *)strToamount
{
    static NSNumberFormatter * numFormatter = nil;
    
    if ( numFormatter == nil )
    {
        numFormatter = [[NSNumberFormatter alloc] init];
    }
    
    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *str = [numFormatter stringFromNumber:[NSNumber numberWithDouble:self.doubleValue]];
    
    if ( str && str.length )
    {
        if ( [str rangeOfString:@"."].location == NSNotFound )
        {
            // 不包含小数点
            str = [str stringByAppendingString:@".00"];
        }
        else
        {
            // 包含
            if ( [[str componentsSeparatedByString:@"."] lastObject].length >= 2 )
            {
                // 不加
            }
            else
            {
                // 加上一个
                str = [str stringByAppendingString:@"0"];
            }
        }
    }
    
    return str;
}


@end

