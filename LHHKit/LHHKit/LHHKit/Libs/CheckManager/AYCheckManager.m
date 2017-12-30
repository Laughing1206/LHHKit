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



#import "AYCheckManager.h"
#import <StoreKit/StoreKit.h>
#import "AFNetworking.h"
#define REQUEST_SUCCEED 200

#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define BUNDLE_IDENTIFIER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

#define SYSTEM_VERSION_8_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))

#define TRACK_ID @"TRACKID"

#define APP_LAST_VERSION @"APPLastVersion"

#define APP_RELEASE_NOTES @"APPReleaseNotes"

#define APP_TRACK_VIEW_URL @"APPTRACKVIEWURL"

#define SPECIAL_MODE_CHECK_URL @"https://itunes.apple.com/lookup?country=%@&bundleId=%@"

#define NORMAL_MODE_CHECK_URL @"https://itunes.apple.com/lookup?bundleId=%@"

#define SKIP_CURRENT_VERSION @"SKIPCURRENTVERSION"

#define SKIP_VERSION @"SKIPVERSION"

@interface AYCheckManager ()<SKStoreProductViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) NSString *nextTimeTitle;

@property (nonatomic, copy) NSString *confimTitle;

@property (nonatomic, copy) NSString *alertTitle;

@property (nonatomic, copy) NSString *skipVersionTitle;

@end

@implementation AYCheckManager

static AYCheckManager *checkManager = nil;
+ (instancetype)sharedCheckManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checkManager = [[AYCheckManager alloc] init];
        checkManager.nextTimeTitle = @"稍后再说";
        checkManager.confimTitle = @"前往更新";
        checkManager.alertTitle = @"检测到新版本";
        checkManager.skipVersionTitle = nil;
    });
    return checkManager;
}

- (void)checkVersion {
    
    [self checkVersionWithAlertTitle:self.alertTitle nextTimeTitle:self.nextTimeTitle confimTitle:self.confimTitle];
}

- (void)checkVersionWithAlertTitle:(NSString *)alertTitle nextTimeTitle:(NSString *)nextTimeTitle confimTitle:(NSString *)confimTitle {
    
    [self checkVersionWithAlertTitle:alertTitle nextTimeTitle:nextTimeTitle confimTitle:confimTitle skipVersionTitle:nil];
}

- (void)checkVersionWithAlertTitle:(NSString *)alertTitle nextTimeTitle:(NSString *)nextTimeTitle confimTitle:(NSString *)confimTitle skipVersionTitle:(NSString *)skipVersionTitle {
    
    self.alertTitle = alertTitle;
    self.nextTimeTitle = nextTimeTitle;
    self.confimTitle = confimTitle;
    self.skipVersionTitle = skipVersionTitle;
    [checkManager getInfoFromAppStore];
}

- (void)getInfoFromAppStore {
    
    NSString *requestURL;
    if (self.countryAbbreviation == nil) {
        requestURL = [NSString stringWithFormat:NORMAL_MODE_CHECK_URL,BUNDLE_IDENTIFIER];
    } else {
        requestURL = [NSString stringWithFormat:SPECIAL_MODE_CHECK_URL,self.countryAbbreviation,@"com.renrengongyiwang"];
    }
    
    AFHTTPSessionManager * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    //设置请求超时时间
    manager.requestSerializer.timeoutInterval = 60;

    [manager POST:requestURL parameters:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"resultCount"] intValue] == 1) {
            NSArray *results = responseObject[@"results"];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSDictionary *resultDic = [results firstObject];
            [userDefault setObject:resultDic[@"version"] forKey:APP_LAST_VERSION];
            [userDefault setObject:resultDic[@"releaseNotes"] forKey:APP_RELEASE_NOTES];
            [userDefault setObject:resultDic[@"trackViewUrl"] forKey:APP_TRACK_VIEW_URL];
            [userDefault setObject:[resultDic[@"trackId"] stringValue] forKey:TRACK_ID];
            NSLog(@"%@" , resultDic[@"version"]);
            if ([resultDic[@"version"] isEqualToString:CURRENT_VERSION] || ![[userDefault objectForKey:SKIP_VERSION] isEqualToString:resultDic[@"version"]])
            {
                [userDefault setBool:NO forKey:SKIP_CURRENT_VERSION];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![[userDefault objectForKey:SKIP_CURRENT_VERSION] boolValue])
                {
                    NSArray *AppStoreVersionArray = [resultDic[@"version"] componentsSeparatedByString:@"."];
                    NSArray *localVersionArray = [CURRENT_VERSION componentsSeparatedByString:@"."];
                    for (int index = 0; index < AppStoreVersionArray.count; index ++)
                    {
                        if ([AppStoreVersionArray[index] intValue] > [localVersionArray[index] intValue])
                        {
                            [self compareWithCurrentVersion];
                            break;
                        }
                    }
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)compareWithCurrentVersion {
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *updateMessage = [userDefault objectForKey:APP_RELEASE_NOTES];
//    if (![[userDefault objectForKey:APP_LAST_VERSION] isEqualToString:CURRENT_VERSION]) {
//        __weak typeof(self) weakSelf = self;
//        NSString *phoneNumber = PhoneNumber();
//        if (phoneNumber && ![phoneNumber isEqualToString:@"13720038572"]) {
//        DFWUpdateView *updateView = [[DFWUpdateView alloc] init];
//        [updateView showWithVersion:[userDefault objectForKey:APP_LAST_VERSION] message:updateMessage tapBlock:^(BOOL isUpdate) {
//            if (isUpdate) {
//                [weakSelf openAPPStore];
//            }
//        }];
//        }
//    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    
    if (buttonIndex == 0) {

    } else {
        
        [self openAPPStore];
    }
}

- (void)openAPPStore {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (!self.openAPPStoreInsideAPP) {
        NSString *str = [userDefault objectForKey:APP_TRACK_VIEW_URL];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
#pragma clang diagnostic pop
    } else {
        SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
        storeViewController.delegate = self;
        
        NSDictionary *parametersDic = @{SKStoreProductParameterITunesItemIdentifier:[userDefault objectForKey:TRACK_ID]};
        [storeViewController loadProductWithParameters:parametersDic completionBlock:^(BOOL result, NSError * _Nullable error) {
            
            if (result) {
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:storeViewController animated:YES completion:^{
                    
                }];
            }
        }];
    }
    
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
