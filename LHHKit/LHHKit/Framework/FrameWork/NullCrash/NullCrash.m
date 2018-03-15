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

#import "NullCrash.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////

@interface NullCrashLogs : NSObject

+ (NSString *)crashReason:(NSString *)reson
                  release:(NSString *)releaseLog
                 otherLog:(NSString *)otherLog;

@end

@implementation NullCrashLogs

+ (NSString *)crashReason:(NSString *)reson
                  release:(NSString *)releaseLog
                 otherLog:(NSString *)otherLog
{
    NSMutableString *mutStr = [NSMutableString string];
    [mutStr appendString:@"\n \n/**NSAssert断言,Crash仅限于Debug模式\n"];
    [mutStr appendString:[NSString stringWithFormat:@"/**Crash原因:%@ \n",reson]];
    [mutStr appendString:[NSString stringWithFormat:@"/**Release模式下:%@ \n",releaseLog]];
    
    if ([NullEmpty isString:otherLog]) {
        [mutStr appendString:[NSString stringWithFormat:@"/**其它:%@ \n",otherLog]];
    }
    
    return (NSString *)mutStr;
}

@end

////////////////////////////////////////////////////////////////

@implementation NullEmpty

+ (BOOL)isArray:(id)object
{
    return [object isKindOfClass:[NSArray class]] && [(NSArray*)object count] > 0;
}

+ (BOOL)isSet:(id)object
{
    
    return [object isKindOfClass:[NSSet class]] && [(NSSet*)object count] > 0;
}

+ (BOOL)isString:(id)text
{
    return [text isKindOfClass:[NSString class]] && [(NSString*)text length] > 0;
}

+ (BOOL)isDictionary:(id)object
{
    return [object isKindOfClass:[NSDictionary class]] && [(NSDictionary *)object count] >0;
}

@end

////////////////////////////////////////////////////////////////

@interface NSArray (NullCrash)
@end

@implementation NSArray (NullCrash)

+ (void)load
{
    array_method_exchangeClass(objc_getClass("__NSArrayI"));
}

void array_method_exchangeClass(Class cls) {
    
    array_method_exchangeImplementations(cls,@selector(objectAtIndex:), @selector(safeObjectAtIndex:));
    array_method_exchangeImplementations(cls,@selector(indexOfObject:), @selector(safeIndexOfObject:));
}


void array_method_exchangeImplementations(Class cls, SEL name, SEL name2) {
    
    Method fromMethod = class_getInstanceMethod(cls, name);
    Method toMethod = class_getInstanceMethod(cls, name2);
    method_exchangeImplementations(fromMethod, toMethod);
}


- (NSUInteger)safeIndexOfObject:(id)anObject
{
    NSAssert((anObject && [self containsObject:anObject]),([NullCrashLogs crashReason:@"元素不存在"
                                                                                 release:@"返回0"
                                                                                otherLog:nil]));
    if (anObject && [self containsObject:anObject]) {
        return [self safeIndexOfObject:anObject];
    } else {
        return 0;
    }
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    NSAssert((index < self.count),([NullCrashLogs crashReason:@"数组越界"
                                                         release:@"返回nil"
                                                        otherLog:[NSString stringWithFormat:@"数组Count:%@ 参数下标index:%@",@(self.count),@(index)]]));
    if (index < self.count){
        return [self safeObjectAtIndex:index];
    }else{
        return nil;
    }
}

@end

///////////////////////////////////////////////////////////

@interface NSMutableArray (NullCrash)
@end

@implementation NSMutableArray (NullCrash)

+ (void)load
{
    mutArray_method_exchangeImplementations(@selector(addObject:), @selector(safeAddObject:));
    
    mutArray_method_exchangeImplementations(@selector(insertObject:atIndex:),@selector(safeInsertObject:atIndex:));
    
    mutArray_method_exchangeImplementations(@selector(removeObjectAtIndex:),@selector(safeRemoveObjectAtIndex:));
}

- (void)safeAddObject:(id)anObject
{
    NSAssert((anObject), ([NullCrashLogs crashReason:@"被添加的元素不存在"
                                                release:@"不执行该方法"
                                               otherLog:nil]));
    if (anObject) {
        [self safeAddObject:anObject];
    }
}

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    NSAssert((anObject), ([NullCrashLogs crashReason:@"被添加的元素不存在"
                                                release:@"不执行该方法"
                                               otherLog:nil]));
    
    if (anObject) {
        [self safeInsertObject:anObject atIndex:index];
    }
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    NSAssert((index < self.count), ([NullCrashLogs crashReason:@"被移除的元素index越界"
                                                          release:@"不执行该方法"
                                                         otherLog:nil]));
    
    if (index < self.count) {
        [self safeRemoveObjectAtIndex:index];
    }
}

Class objc_NSMutArrayClass() {
    
    return objc_getClass("__NSArrayM");
}


void mutArray_method_exchangeImplementations(SEL name, SEL name2) {
    
    Method fromMethod = class_getInstanceMethod(objc_NSMutArrayClass(), name);
    Method toMethod = class_getInstanceMethod(objc_NSMutArrayClass(), name2);
    method_exchangeImplementations(fromMethod, toMethod);
}

@end

/////////////////////////////////////////////////////////////////////

@implementation NSDictionary (NullCrash)

- (NSString *)getStringForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    
    NSAssert(([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]),
             ([NullCrashLogs crashReason:@"无法获取NSString类型"
                                    release:@"返回@"""
                                   otherLog:[NSString stringWithFormat:@"得到的类型是：%@",
                                             NSStringFromClass([obj class])]]));
    
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj stringValue];
    } else {
        return @"";
    }
}

- (NSArray *)getArrayForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    NSAssert(([obj isKindOfClass:[NSArray class]]),
             ([NullCrashLogs crashReason:@"无法获取NSArray类型"
                                    release:@"返回[NSArray array]实例"
                                   otherLog:[NSString stringWithFormat:@"得到的类型是：%@",
                                             NSStringFromClass([obj class])]]));
    
    if ([obj isKindOfClass:[NSArray class]]) {
        return (NSArray *)obj;
    } else {
        return [NSArray array];
    }
}


- (NSDictionary *)getDictinaryForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    NSAssert(([obj isKindOfClass:[NSDictionary class]]),
             ([NullCrashLogs crashReason:@"无法获取NSDictionary类型"
                                    release:@"返回[NSDictionary dictionary]实例"
                                   otherLog:[NSString stringWithFormat:@"得到的类型是：%@",
                                             NSStringFromClass([obj class])]]));
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)obj;
    } else {
        return [NSDictionary dictionary];
    }
}

- (int)getIntForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    NSAssert(([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]),
             ([NullCrashLogs crashReason:@"不是NSString或NSNumber，无法转化成int类型"
                                    release:@"返回0"
                                   otherLog:[NSString stringWithFormat:@"得到的类型是：%@",
                                             NSStringFromClass([obj class])]]));
    
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
        return  [obj intValue];
    } else {
        return 0;
    }
}

- (float)getFloatForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    NSAssert(([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]),
             ([NullCrashLogs crashReason:@"不是NSString或NSNumber，无法转化成float类型"
                                    release:@"返回0"
                                   otherLog:[NSString stringWithFormat:@"得到的类型是：%@",
                                             NSStringFromClass([obj class])]]));
    
    
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
        return  [obj floatValue];
    } else {
        return 0;
    }
}

- (BOOL)getBoolForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    NSAssert(([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]),
             ([NullCrashLogs crashReason:@"不是NSString或NSNumber，无法转化成BOOL类型"
                                    release:@"返回NO"
                                   otherLog:[NSString stringWithFormat:@"得到的类型是：%@",
                                             NSStringFromClass([obj class])]]));
    
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
        return  [obj boolValue];
    } else {
        return NO;
    }
}


@end


///////////////////////////////////////////////////////

@interface NSMutableDictionary (NullCrash)
@end


@implementation NSMutableDictionary (NullCrash)

+ (void)load
{
    Method fromMethod = class_getInstanceMethod(objc_NSMutDictionaryClass(), @selector(setObject:forKey:));
    Method toMethod = class_getInstanceMethod(objc_NSMutDictionaryClass(), @selector(safeSetObject:forKey:));
    method_exchangeImplementations(fromMethod, toMethod);
}

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey;
{
    
    NSAssert((anObject), ([NullCrashLogs crashReason:@"被添加的object不存在"
                                                release:@"不执行该方法"
                                               otherLog:nil]));
    
    NSAssert((aKey), ([NullCrashLogs crashReason:@"被添加的key不存在"
                                            release:@"不执行该方法"
                                           otherLog:nil]));
    
    
    if (anObject && aKey) {
        [self safeSetObject:anObject forKey:aKey];
    }
}

Class objc_NSMutDictionaryClass() {
    
    return objc_getClass("__NSDictionaryM");
}

@end


///////////////////////////////////////////////////////

@interface NSMutableSet (NullCrash)
@end

@implementation NSMutableSet (NullCrash)

+ (void)load
{
    mutSet_method_exchangeImplementations(@selector(addObject:), @selector(safeAddObject:));
}

- (void)safeAddObject:(id)anObject
{
    NSAssert((anObject), ([NullCrashLogs crashReason:@"被添加的元素不存在"
                                                release:@"不执行该方法"
                                               otherLog:nil]));
    
    if (anObject) {
        [self safeAddObject:anObject];
    }
}

Class objc_NSMutSetClass() {
    
    return objc_getClass("__NSSetM");
}


void mutSet_method_exchangeImplementations(SEL name, SEL name2) {
    
    Method fromMethod = class_getInstanceMethod(objc_NSMutSetClass(), name);
    Method toMethod = class_getInstanceMethod(objc_NSMutSetClass(), name2);
    method_exchangeImplementations(fromMethod, toMethod);
}

@end

