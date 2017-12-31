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
#import <UIKit/UIKit.h>

/**
 *  版本管理类
 */
@interface TWVersionChecker : NSObject

/**
 *  检查appstore是否有新版本
 *
 *  @param appId             要查检的appid
 *  @param completionHandler 检查返回的代理
 */
+ (void)checkVersionForAppId:(NSString *)appId completionHandler:(void (^)(BOOL hasNew, NSString *updateText, NSString *updateUrl, NSString *version))completionHandler;


@end
