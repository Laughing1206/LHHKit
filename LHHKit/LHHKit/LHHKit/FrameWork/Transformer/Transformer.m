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

#import "Transformer.h"


@interface Transformer()

@end


@implementation Transformer

// dictionary转data
+ (NSData*)returnDataWithDictionary:(NSDictionary*)dict
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"talkData"];
    [archiver finishEncoding];
    
    return data;
}

// data转dictionary
+ (NSDictionary*)returnDictionaryWithDataPath:(NSString *)path
{
    NSData* data = [[NSMutableData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary* myDictionary = [unarchiver decodeObjectForKey:@"talkData"];
    [unarchiver finishDecoding];
    return myDictionary;
}

+ (NSDictionary*)returnDictionaryWithData:(NSData*)data
{
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary* myDictionary = [unarchiver decodeObjectForKey:@"talkData"];
    [unarchiver finishDecoding];
    return myDictionary;
}

// 字典转字符串
+ (NSString *)returnStringWithDictionary:(NSDictionary*)dic WithModel:(JsonStringContentMode*)model
{
    NSString *str = @"";
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (model == JsonModel) {
        return str;
    }else{
        NSScanner *scanner = [[NSScanner alloc] initWithString:str];
        [scanner setCharactersToBeSkipped:nil];
        NSMutableString *result = [[NSMutableString alloc] init];
        NSString *temp;
        NSCharacterSet*newLineAndWhitespaceCharacters = [NSCharacterSet newlineCharacterSet];
        // 扫描
        while (![scanner isAtEnd])
        {
            temp = nil;
            [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
            if (temp) [result appendString:temp];
            
            // 替换换行符
            if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
                if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
                    [result appendString:@""];
            }
            
            // 替换转义符
            
        }
        return result;
    }
}

@end
