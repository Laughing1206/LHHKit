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



#import "AppSplash.h"
#import "SplashWindow.h"
#import "SplashModel.h"

#define AppSplashPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"AppSplash.arch"]
@interface AppSplash ()
@end

@implementation AppSplash

SingletonImplemention(AppSplash)

#pragma mark -

+ (void)load
{
    [AppService addService:[self sharedAppSplash]];
}

#pragma mark -

- (void)setup
{
    [self setupSplash];
    [self updateSplash];
}

#pragma mark -

// 加载splash
- (void)setupSplash
{
    [SplashWindow sharedSplashWindow].model = [self getSplashModel];
    [[SplashWindow sharedSplashWindow] show];
}

// 更新splash
- (void)updateSplash
{
//    [[DFWSubNetworkEngine shareInstance] singlesDayNetworkService:nil succBlock:^(id models, id resultJson) {
//
//        if ([findJSONwithKeyPath(@"returnCode", resultJson) isEqualToString:@"SUCCESS"])
//        {
//            NSString * url = resultJson[@"result"][@"list-index"];
//            NSString * img = resultJson[@"result"][@"star_img"];
//
//            if (img && img.length )
//            {
//                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                    if ( image )
//                    {
//                        // 开始存储图片
//                        [[SDImageCache sharedImageCache] storeImage:image forKey:img toDisk:YES];
//
//                        SplashModel * model = [[SplashModel alloc] init];
//                        model.url = url;
//                        model.img = img;
//                        model.image = image;
//                        model.lastTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
//                        // 保存自定义对象
//                        [NSKeyedArchiver archiveRootObject:model toFile:AppSplashPath];
//                    }
//                }];
//            }
//            else
//            {
//                 [self removeAppSplashPath];
//            }
//        }
//        else
//        {
//            [self removeAppSplashPath];
//        }
//    } failedBlock:^(NSError *error, id resultJson) {
//        [self removeAppSplashPath];
//    }];

}

- (void)removeAppSplashPath
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:AppSplashPath])
    {
        [defaultManager removeItemAtPath:AppSplashPath error:nil];
    }
}

//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    //进入前台 ---applicationDidBecomeActive----
//    // 每次从后台进入前台  都去请求一遍闪屏幕 同时检查是否存在最新的闪屏  如果有  那么就显示最新的闪屏幕
//
//    // 只有在一级页面的时候，才会去显示闪屏   并且不是第一个显示
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if ([appDelegate.window.rootViewController isKindOfClass:[MMDrawerController class]])
//    {
//        MMDrawerController * mmDrawerController = (MMDrawerController *)appDelegate.window.rootViewController;
//
//        if ([mmDrawerController.centerViewController isKindOfClass:[DCTabBarController class]])
//        {
//            DCTabBarController * tabBarController = (DCTabBarController *)mmDrawerController.centerViewController;
//
//            if ( tabBarController.currentViewController.navigationController.viewControllers.count == 1)
//            {
//                [self updateSplash];
//                [self setupSplash];
//            }
//        }
//    }
//}

/**
 * 返回广告数据模型
 */
- (SplashModel *)getSplashModel
{
    SplashModel * model = [NSKeyedUnarchiver unarchiveObjectWithFile:AppSplashPath];
    
    if (model)
    {
        if ([self isPeriodValidityWithFromDay:[model.lastTime doubleValue] limitDay:7])
        {
            if (model.image)
            {
                return model;
            }
            else
            {
                [self clearImageForKey:model.img];
            }
        }
        else
        {
            [self clearImageForKey:model.img];
        }
    }
    return nil;
}

/**
 * 清除缓存的image
 */
- (void)clearImageForKey:(NSString *)key
{
    [[SDImageCache sharedImageCache] removeImageForKey:key withCompletion:nil];
}

- (BOOL)isPeriodValidityWithFromDay:(double)fromDay limitDay:(NSInteger)limitDay
{
    double difference = [[NSDate date] timeIntervalSince1970] - fromDay;
    
    if (difference <= limitDay * 24 * 60 * 60)
    {
        return YES;
    }
    return NO;
}

@end
