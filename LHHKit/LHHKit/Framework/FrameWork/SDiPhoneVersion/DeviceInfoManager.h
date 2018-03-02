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

@interface DeviceInfoManager : NSObject

/** 能否打电话 */
@property (nonatomic, assign, readonly) BOOL canMakePhoneCall NS_EXTENSION_UNAVAILABLE_IOS("");

+ (instancetype)sharedManager;


/** 获取设备型号 */
- (const NSString *)getDeviceName;
/** 获取设备装机时的系统版本（最低支持版本） */
- (const NSString *)getInitialFirmware;
/** 获取设备可支持的最高系统版本 */
- (const NSString *)getLatestFirmware;
/** 获取设备颜色 */
- (NSString *)getDeviceColor;
/** 获取设备外壳颜色 */
- (NSString *)getDeviceEnclosureColor;
/** 获取mac地址 */
- (NSString *)getMacAddress;
/** 获取广告标识符 */
- (NSString *)getIDFA;
- (NSString *)getDeviceModel;
/** 获取设备上次重启的时间 */
- (NSDate *)getSystemUptime;
- (NSUInteger)getCPUFrequency;
/** 获取总线程频率 */
- (NSUInteger)getBusFrequency;
/** 获取当前设备主存 */
- (NSUInteger)getRamSize;

- (NSString *)getCPUProcessor;
/** 获取CPU数量 */
- (NSUInteger)getCPUCount;
/** 获取CPU总的使用百分比 */
- (float)getCPUUsage;
/** 获取单个CPU使用百分比 */
- (NSArray *)getPerCPUUsage;


/** 获取本 App 所占磁盘空间 */
- (NSString *)getApplicationSize;
/** 获取磁盘总空间 */
- (int64_t)getTotalDiskSpace;
/** 获取未使用的磁盘空间 */
- (int64_t)getFreeDiskSpace;
/** 获取已使用的磁盘空间 */
- (int64_t)getUsedDiskSpace;

/** 获取总内存空间 */
- (int64_t)getTotalMemory;
/** 获取活跃的内存空间 */
- (int64_t)getActiveMemory;
/** 获取不活跃的内存空间 */
- (int64_t)getInActiveMemory;
/** 获取空闲的内存空间 */
- (int64_t)getFreeMemory;
/** 获取正在使用的内存空间 */
- (int64_t)getUsedMemory;
/** 获取存放内核的内存空间 */
- (int64_t)getWiredMemory;
/** 获取可释放的内存空间 */
- (int64_t)getPurgableMemory;

@end
