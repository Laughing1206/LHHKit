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

@interface DeviceDataLibrery : NSObject

+ (instancetype)sharedLibrery;
/** 获取设备名称 */
- (const NSString *)getDiviceName;
/** 获取设备初始系统型号 */
- (const NSString *)getInitialVersion;
/** 获取设备支持的最高系统型号 */
- (const NSString *)getLatestVersion;
/** 获取设备电池容量，单位 mA 毫安 */
- (NSInteger)getBatteryCapacity;
/** 获取电池电压，单位 V 福特 */
- (CGFloat)getBatterVolocity;
/** 获取CPU处理器名称 */
- (const NSString *)getCPUProcessor;

@end
