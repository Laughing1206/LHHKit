//
//  DeepLink.m
//  RenRenCiShanJia
//
//  Created by 李欢欢 on 2017/11/23.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//

#import "DeepLink.h"
#import "AppService.h"
#import "AppDelegate.h"

@interface DeepLink ()
@property (nonatomic, strong) NSURL * currentUrl;
@end
@implementation DeepLink

SingletonImplemention(DeepLink)

+ (void)load
{
    [AppService addService:[self sharedDeepLink]];
}

- (void)powerOn
{
    [self setupRouter];
}

- (void)setupRouter
{
    self.router = [[DPLDeepLinkRouter alloc] init];
    
    @weakify(self);
    
    self.router[@"http://"] = ^( DPLDeepLink * link ) {
        @strongify(self);
        self.currentUrl = link.URL;
        [self pushWebViewWithUrl:link.URL];
    };
    
    self.router[@"https://"] = ^( DPLDeepLink * link ) {
        @strongify(self);
        self.currentUrl = link.URL;
        [self pushWebViewWithUrl:link.URL];
    };
    
    self.router[@"/:where/:action"] = ^( DPLDeepLink * link ) {
        @strongify(self);
        self.currentUrl = link.URL;
        NSString * where = link.routeParameters[@"where"];
        NSString * action = link.routeParameters[@"action"];
        action = [action URLDecoding];
        if ( [where isEqualToString:@"goodsInfo"] )
        {
            [self pushGoodsInfoWithId:action];
        }
    };
}

- (void)pushWebViewWithUrl:(NSURL *)url
{
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//    if ( ![Validator isURL:[NSString stringWithFormat:@"%@",url.absoluteString]])
//    {
//        [appDelegate.currentCenterViewController presentMessageTips:@"无法识别的内容"];
//        return;
//    }
//    else
//    {
//        WebViewController * webViewController = [[WebViewController alloc] init];
//        webViewController.urlString = url.absoluteString;
//
//        if (appDelegate.currentCenterViewController.childViewControllers)
//        {
//            DCNavigationController * navigationController = (DCNavigationController *) [appDelegate.currentCenterViewController.childViewControllers safeObjectAtIndex:0];
//            [navigationController pushViewController:webViewController animated:YES];
//        }
//    }
}

/**
 商品详情
 */
- (void)pushGoodsInfoWithId:(NSString *)productId
{
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//    if ( ![Validator isNumOrLetter:productId])
//    {
//        [appDelegate.currentCenterViewController presentMessageTips:@"无法识别的内容"] ;
//        return;
//    }
//
//    ProductsDetailViewController * productsDetailViewController = [[ProductsDetailViewController alloc]init];
//    productsDetailViewController.goodsID = productId;
//    [appDelegate.currentCenterViewController.currentViewController.navigationController pushViewController:productsDetailViewController animated:YES];
}

- (BOOL)isOpenWithUrl:(NSString *)url
{
    if ( [url hasPrefix:@"renrenbaiyi://rrby/goodsInfo"] )
    {
        // 商品详情
        return YES;
    }
    else if ( [url hasPrefix:@"http://"] )
    {
        return YES;
    }
    else if ( [url hasPrefix:@"https://"] )
    {
        return YES;
    }
    return NO;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ( [self isOpenWithUrl:url.absoluteString] )
    {
        return [self.router handleURL:url withCompletion:nil];
    }
    
    return YES;
}

#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ( [self isOpenWithUrl:url.absoluteString] )
    {
        return [self.router handleURL:url withCompletion:nil];
    }
    
    return YES;
}
#endif

@end
