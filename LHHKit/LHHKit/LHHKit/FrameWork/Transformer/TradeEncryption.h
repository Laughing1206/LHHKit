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

FOUNDATION_EXPORT NSString * const TRACE_ENCRYPTION_KEY;

@interface TradeEncryption : NSObject

+ (NSData *) encrypt:(NSData *)data key:(NSData *)key sign:(BOOL)sign;
+ (NSData *) encrypt:(NSData *)data stringKey:(NSString *)key sign:(BOOL)sign;

+ (NSString *) encryptToBase64String:(NSData *)data key:(NSData *)key sign:(BOOL)sign;
+ (NSString *) encryptToBase64String:(NSData *)data stringKey:(NSString *)key sign:(BOOL)sign;

+ (NSData *) encryptString:(NSString *)data key:(NSData *)key sign:(BOOL)sign;
+ (NSData *) encryptString:(NSString *)data stringKey:(NSString *)key sign:(BOOL)sign;

+ (NSString *) encryptStringToBase64String:(NSString *)data key:(NSData *)key sign:(BOOL)sign;
+ (NSString *) encryptStringToBase64String:(NSString *)data stringKey:(NSString *)key sign:(BOOL)sign;

+ (NSData *) decrypt:(NSData *)data key:(NSData *)key sign:(BOOL)sign ;
+ (NSData *) decrypt:(NSData *)data stringKey:(NSString *)key sign:(BOOL)sign ;

+ (NSData *) decryptBase64String:(NSString *)data key:(NSData *)key sign:(BOOL)sign;
+ (NSData *) decryptBase64String:(NSString *)data stringKey:(NSString *)key sign:(BOOL)sign ;

+ (NSString *) decryptToString:(NSData *)data key:(NSData *)key sign:(BOOL)sign ;
+ (NSString *) decryptToString:(NSData *)data stringKey:(NSString *)key sign:(BOOL)sign ;

+ (NSString *) decryptBase64StringToString:(NSString *)data key:(NSData *)key sign:(BOOL)sign ;
+ (NSString *) decryptBase64StringToString:(NSString *)data stringKey:(NSString *)key sign:(BOOL)sign ;

@end

@interface NSData (TradeEncryption)

- (NSData *) xxteaEncrypt:(NSData *)key sign:(BOOL)sign;
- (NSData *) xxteaDecrypt:(NSData *)key sign:(BOOL)sign ;

@end
