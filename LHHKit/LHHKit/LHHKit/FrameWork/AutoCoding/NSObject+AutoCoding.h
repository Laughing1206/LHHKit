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

@protocol AutoModelCoding <NSObject>
+ (id)processedValueForKey:(NSString *)key
               originValue:(id)originValue
            convertedValue:(id)convertedValue
                     class:(__unsafe_unretained Class)clazz
                  subClass:(__unsafe_unretained Class)subClazz;
@end

@interface NSObject (AutoModelCoding)

- (instancetype)ac_clone;

+ (instancetype)ac_objectWithAny:(id)any;
+ (instancetype)ac_objectWithDictionary:(NSDictionary *)dictionary;
+ (id)ac_objectsWithArray:(NSArray *)array objectClass:(Class)clazz;

- (NSString *)JSONStringRepresentation;

@end
