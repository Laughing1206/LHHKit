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

@protocol BatteryInfoDelegate
- (void)batteryStatusUpdated;
@end

@interface BatteryInfoManager : NSObject

@property (nonatomic, weak) id<BatteryInfoDelegate> delegate;

@property (nonatomic, assign) NSUInteger capacity;
@property (nonatomic, assign) CGFloat voltage;

@property (nonatomic, assign) NSUInteger levelPercent;
@property (nonatomic, assign) NSUInteger levelMAH;
@property (nonatomic, copy)   NSString *status;

+ (instancetype)sharedManager;
/** 开始监测电池电量 */
- (void)startBatteryMonitoring;
/** 停止监测电池电量 */
- (void)stopBatteryMonitoring;

@end
