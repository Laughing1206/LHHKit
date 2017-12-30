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


#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

- (BOOL)hasObjectForKey:(id)key
{
    return [self objectForKey:key] ? YES : NO;
}

- (id)objectForOneOfKeys:(NSArray *)array
{
    for ( NSString * key in array )
    {
        NSObject * obj = [self objectForKey:key];
        
        if ( obj )
        {
            return obj;
        }
    }
    
    return nil;
}

- (NSNumber *)numberForOneOfKeys:(NSArray *)array
{
    NSObject * obj = [self objectForOneOfKeys:array];
    
    if ( nil == obj )
    {
        return nil;
    }
    
    return [obj toNumber];
}

- (NSString *)stringForOneOfKeys:(NSArray *)array
{
    NSObject * obj = [self objectForOneOfKeys:array];
    
    if ( nil == obj )
    {
        return nil;
    }
    
    return [obj toString];
}

- (id)objectAtPath:(NSString *)path
{
    return [self objectAtPath:path separator:nil];
}

- (id)objectAtPath:(NSString *)path separator:(NSString *)separator
{
    if ( nil == separator )
    {
        path = [path stringByReplacingOccurrencesOfString:@"." withString:@"/"];
        separator = @"/";
    }
    
    NSArray * array = [path componentsSeparatedByString:separator];
    if ( 0 == [array count] )
    {
        return nil;
    }
    
    NSObject * result = nil;
    NSDictionary * dict = self;
    
    for ( NSString * subPath in array )
    {
        if ( 0 == [subPath length] )
            continue;
        
        result = [dict objectForKey:subPath];
        if ( nil == result )
            return nil;
        
        if ( [array lastObject] == subPath )
        {
            return result;
        }
        else if ( NO == [result isKindOfClass:[NSDictionary class]] )
        {
            return nil;
        }
        
        dict = (NSDictionary *)result;
    }
    
    return (result == [NSNull null]) ? nil : result;
}

- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other
{
    NSObject * obj = [self objectAtPath:path];
    
    return obj ? obj : other;
}

- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other separator:(NSString *)separator
{
    NSObject * obj = [self objectAtPath:path separator:separator];
    
    return obj ? obj : other;
}

- (id)objectAtPath:(NSString *)path withClass:(Class)clazz
{
    return [self objectAtPath:path withClass:clazz otherwise:nil];
}

- (id)objectAtPath:(NSString *)path withClass:(Class)clazz otherwise:(NSObject *)other
{
    NSObject * obj = [self objectAtPath:path];
    
    if ( obj && [obj isKindOfClass:[NSDictionary class]] )
    {
        obj = [clazz unserialize:obj];
    }
    
    return obj ? obj : other;
}

- (BOOL)boolAtPath:(NSString *)path
{
    return [self boolAtPath:path otherwise:NO];
}

- (BOOL)boolAtPath:(NSString *)path otherwise:(BOOL)other
{
    NSObject * obj = [self objectAtPath:path];
    
    if ( [obj isKindOfClass:[NSNull class]] )
    {
        return NO;
    }
    else if ( [obj isKindOfClass:[NSNumber class]] )
    {
        return [(NSNumber *)obj intValue] ? YES : NO;
    }
    else if ( [obj isKindOfClass:[NSString class]] )
    {
        if ( [(NSString *)obj hasPrefix:@"y"] || [(NSString *)obj hasPrefix:@"Y"] ||
            [(NSString *)obj hasPrefix:@"T"] || [(NSString *)obj hasPrefix:@"t"] ||
            [(NSString *)obj isEqualToString:@"1"] )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return other;
}

- (NSNumber *)numberAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    
    if ( [obj isKindOfClass:[NSNull class]] )
    {
        return nil;
    }
    else if ( [obj isKindOfClass:[NSNumber class]] )
    {
        return (NSNumber *)obj;
    }
    else if ( [obj isKindOfClass:[NSString class]] )
    {
        return [NSNumber numberWithDouble:[(NSString *)obj doubleValue]];
    }
    
    return nil;
}

- (NSNumber *)numberAtPath:(NSString *)path otherwise:(NSNumber *)other
{
    NSNumber * obj = [self numberAtPath:path];
    
    return obj ? obj : other;
}

- (NSString *)stringAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    
    if ( [obj isKindOfClass:[NSNull class]] )
    {
        return nil;
    }
    else if ( [obj isKindOfClass:[NSNumber class]] )
    {
        return [NSString stringWithFormat:@"%d", [(NSNumber *)obj intValue]];
    }
    else if ( [obj isKindOfClass:[NSString class]] )
    {
        return (NSString *)obj;
    }
    
    return nil;
}

- (NSString *)stringAtPath:(NSString *)path otherwise:(NSString *)other
{
    NSString * obj = [self stringAtPath:path];
    
    return obj ? obj : other;
}

- (NSArray *)arrayAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    
    return [obj isKindOfClass:[NSArray class]] ? (NSArray *)obj : nil;
}

- (NSArray *)arrayAtPath:(NSString *)path otherwise:(NSArray *)other
{
    NSArray * obj = [self arrayAtPath:path];
    
    return obj ? obj : other;
}

- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz
{
    return [self arrayAtPath:path withClass:clazz otherwise:nil];
}

- (NSArray *)arrayAtPath:(NSString *)path withClass:(Class)clazz otherwise:(NSArray *)other
{
    NSArray * array = [self arrayAtPath:path otherwise:nil];
    
    if ( array )
    {
        NSMutableArray * results = [NSMutableArray array];
        
        for ( NSObject * obj in array )
        {
            if ( [obj isKindOfClass:[NSDictionary class]] )
            {
                [results addObject:[clazz unserialize:obj]];
            }
        }
        
        return results;
    }
    
    return other;
}

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    
    return [obj isKindOfClass:[NSMutableArray class]] ? (NSMutableArray *)obj : nil;
}

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path otherwise:(NSMutableArray *)other
{
    NSMutableArray * obj = [self mutableArrayAtPath:path];
    
    return obj ? obj : other;
}

- (NSDictionary *)dictAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    
    return [obj isKindOfClass:[NSDictionary class]] ? (NSDictionary *)obj : nil;
}

- (NSDictionary *)dictAtPath:(NSString *)path otherwise:(NSDictionary *)other
{
    NSDictionary * obj = [self dictAtPath:path];
    
    return obj ? obj : other;
}

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path
{
    NSObject * obj = [self objectAtPath:path];
    
    return [obj isKindOfClass:[NSMutableDictionary class]] ? (NSMutableDictionary *)obj : nil;
}

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path otherwise:(NSMutableDictionary *)other
{
    NSMutableDictionary * obj = [self mutableDictAtPath:path];
    
    return obj ? obj : other;
}

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *msr = [NSMutableString string];
    [msr appendString:@"{"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [msr appendFormat:@"\n\t%@ = %@,",key,obj];
    }];
    //去掉最后一个逗号（,）
    if ([msr hasSuffix:@","])
    {
        NSString *str = [msr substringToIndex:msr.length - 1];
        msr = [NSMutableString stringWithString:str];
    }
    [msr appendString:@"\n}"];
    return msr;
}

@end
