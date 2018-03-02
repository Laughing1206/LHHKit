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

#undef    BASE_CLASS
#define BASE_CLASS( __class ) \
+ (Class)baseClass \
{ \
return NSClassFromString( @(#__class) ); \
}

#undef    CONVERT_CLASS
#define    CONVERT_CLASS( __name, __class ) \
+ (Class)convertClass_##__name \
{ \
return NSClassFromString( @(#__class) ); \
}

@interface NSObject (Extension)
+ (Class)baseClass;

+ (id)unserializeForUnknownValue:(id)value;
+ (id)serializeForUnknownValue:(id)value;

- (void)deepEqualsTo:(id)obj;
- (void)deepCopyFrom:(id)obj;

+ (id)unserialize:(id)obj;
+ (id)unserialize:(id)obj withClass:(Class)clazz;

- (id)JSONEncoded;
- (id)JSONDecoded;

- (BOOL)toBool;
- (float)toFloat;
- (double)toDouble;
- (NSInteger)toInteger;
- (NSUInteger)toUnsignedInteger;

- (NSURL *)toURL;
- (NSDate *)toDate;
- (NSData *)toData;
- (NSNumber *)toNumber;
- (NSString *)toString;

- (id)clone;                    // override point
- (id)serialize;                // override point
- (void)unserialize:(id)obj;    // override point
- (void)zerolize;                // override point

+ (const char *)attributesForProperty:(NSString *)property;
- (const char *)attributesForProperty:(NSString *)property;

+ (NSDictionary *)extentionForProperty:(NSString *)property;
- (NSDictionary *)extentionForProperty:(NSString *)property;

+ (NSString *)extentionForProperty:(NSString *)property stringValueWithKey:(NSString *)key;
- (NSString *)extentionForProperty:(NSString *)property stringValueWithKey:(NSString *)key;

+ (NSArray *)extentionForProperty:(NSString *)property arrayValueWithKey:(NSString *)key;
- (NSArray *)extentionForProperty:(NSString *)property arrayValueWithKey:(NSString *)key;

- (id)getAssociatedObjectForKey:(const char *)key;
- (id)copyAssociatedObject:(id)obj forKey:(const char *)key;
- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;
- (id)assignAssociatedObject:(id)obj forKey:(const char *)key;
- (void)removeAssociatedObjectForKey:(const char *)key;
- (void)removeAllAssociatedObjects;

+ (instancetype)spawn;

+ (void *)swizz:(Class)clazz selector:(SEL)sel1 with:(SEL)sel2;
@end

@interface NSObject (AppRuntime)

+ (NSArray *)selectorNamesOfProtocol:(NSString *)protocol;

@end

