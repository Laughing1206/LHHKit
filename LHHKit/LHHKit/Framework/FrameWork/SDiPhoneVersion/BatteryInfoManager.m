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



#import "BatteryInfoManager.h"
#import "DeviceDataLibrery.h"

@interface BatteryInfoManager ()

@property (nonatomic, assign) BOOL batteryMonitoringEnabled;

@end

@implementation BatteryInfoManager

+ (instancetype)sharedManager {
    static BatteryInfoManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[BatteryInfoManager alloc] init];
    });
    return _manager;
}

- (void)startBatteryMonitoring {
    if (!self.batteryMonitoringEnabled) {
        self.batteryMonitoringEnabled = YES;
        UIDevice *device = [UIDevice currentDevice];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_batteryLevelUpdatedCB:)
                                                     name:UIDeviceBatteryLevelDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_batteryStatusUpdatedCB:)
                                                     name:UIDeviceBatteryStateDidChangeNotification
                                                   object:nil];
        
        [device setBatteryMonitoringEnabled:YES];
        
        // If by any chance battery value is available - update it immediately
        if ([device batteryState] != UIDeviceBatteryStateUnknown) {
            [self _doUpdateBatteryStatus];
        }
    }
}

- (void)stopBatteryMonitoring {
    if (self.batteryMonitoringEnabled) {
        self.batteryMonitoringEnabled = NO;
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - Private Method

- (void)_batteryLevelUpdatedCB:(NSNotification*)notification {
    [self _doUpdateBatteryStatus];
}

- (void)_batteryStatusUpdatedCB:(NSNotification*)notification {
    [self _doUpdateBatteryStatus];
}

- (void)_doUpdateBatteryStatus {
    float batteryMultiplier = [[UIDevice currentDevice] batteryLevel];
    self.levelPercent = batteryMultiplier * 100;
    self.levelMAH =  self.capacity * batteryMultiplier;
    
    switch ([[UIDevice currentDevice] batteryState]) {
        case UIDeviceBatteryStateCharging:
            // UIDeviceBatteryStateFull seems to be overwritten by UIDeviceBatteryStateCharging
            // when charging therefore it's more reliable if we check the battery level here
            // explicitly.
            if (self.levelPercent == 100) {
                self.status = @"Fully charged";
            } else {
                self.status = @"Charging";
            }
            break;
        case UIDeviceBatteryStateFull:
            self.status = @"Fully charged";
            break;
        case UIDeviceBatteryStateUnplugged:
            self.status = @"Unplugged";
            break;
        case UIDeviceBatteryStateUnknown:
            self.status = @"Unknown";
            break;
    }
    
    [self.delegate batteryStatusUpdated];
}

#pragma mark - Setters && Getters
- (CGFloat)voltage {
    return [[DeviceDataLibrery sharedLibrery] getBatterVolocity];
}

- (NSUInteger)capacity {
    return [[DeviceDataLibrery sharedLibrery] getBatteryCapacity];
}

@end
