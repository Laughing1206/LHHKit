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
@interface Transformer : NSObject

typedef NS_ENUM(NSInteger, JsonStringContentMode) {
    JsonModel = 0,
    ServiceModel,
};


/**
 *  字典转data（解归档的形式）
 *
 *  @param dict dic
 *
 *  @return 返回一个data
 */
+ (NSData*)returnDataWithDictionary:(NSDictionary*)dict;
/**
 *  data转字典（解归档的形式）
 *
 *  @param path data路径
 *
 *  @return 返回一个字典
 */
+ (NSDictionary*)returnDictionaryWithDataPath:(NSString *)path;

+ (NSDictionary*)returnDictionaryWithData:(NSData*)data;

/**
 *  字典转字符串
 *
 *  @param dic   dic
 *  @param model 字符串的格式
 *
 *  @return 返回一个转换完成的字符串
 */
+ (NSString *)returnStringWithDictionary:(NSDictionary*)dic WithModel:(JsonStringContentMode*)model;
@end
