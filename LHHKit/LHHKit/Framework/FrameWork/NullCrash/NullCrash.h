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

@interface NullEmpty : NSObject

+ (BOOL)isArray:(id)object;

+ (BOOL)isSet:(id)object;

+ (BOOL)isString:(id)text;

+ (BOOL)isDictionary:(id)object;

@end


@interface NSDictionary (NullCrash)

- (NSString *)getStringForKey:(id)key;

- (NSArray *)getArrayForKey:(id)key;

- (NSDictionary *)getDictinaryForKey:(id)key;

- (int)getIntForKey:(id)key;

- (float)getFloatForKey:(id)key;

- (BOOL)getBoolForKey:(id)key;

@end
