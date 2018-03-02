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

@protocol NSMutableDictionaryProtocol <NSObject>
@required
- (void)setObject:(id)object forKey:(id)key;
- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;
@optional
- (void)setObject:(id)obj forKeyedSubscript:(id)key;
@end

#pragma mark -

@interface NSMutableDictionary(Extension) <NSDictionaryProtocol, NSMutableDictionaryProtocol>

+ (NSMutableDictionary *)nonRetainingDictionary;
+ (NSMutableDictionary *)keyValues:(id)first, ...;

- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path;
- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path separator:(NSString *)separator;
- (id)setKeyValues:(id)first, ...;

- (id)objectForOneOfKeys:(NSArray *)array remove:(BOOL)flag;

- (NSNumber *)numberForOneOfKeys:(NSArray *)array remove:(BOOL)flag;
- (NSString *)stringForOneOfKeys:(NSArray *)array remove:(BOOL)flag;

@end
