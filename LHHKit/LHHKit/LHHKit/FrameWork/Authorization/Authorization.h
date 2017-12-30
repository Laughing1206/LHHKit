//
//  Authorization.h
//  LHHKit
//
//  Created by 李欢欢 on 2017/11/26.
//  Copyright © 2017年 Lihuanhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

/**
 *  发送通知的时机，是delegate之前，还是之后？参考系统控件：UITextField
 */

FOUNDATION_EXTERN NSString *const AuthorizationWasFailedNotification;
FOUNDATION_EXTERN NSString *const AuthorizationWasSucceedNotification;
FOUNDATION_EXTERN NSString *const AuthorizationWasInvalidNotification;
FOUNDATION_EXTERN NSString *const AuthorizationWasCancelledNotification;

#pragma mark -

@protocol AuthorizationDelegate <NSObject>
- (void)authorizationWasFailed;
- (void)authorizationWasSucceed;
- (void)authorizationWasInvalid;
- (void)authorizationWasCancelled;
@end

#pragma mark -

@interface Authorization : NSObject

SingletonInterface(Authorization)

@property (nonatomic, weak) UIViewController<AuthorizationDelegate> * delegate;

- (void)showAuth;
- (void)hideAuth;
- (void)showAuthWithCompletion:(void (^)(void))completion;
- (void)hideAuthWithCompletion:(void (^)(void))completion;
+ (void)showAuthIn:(UIViewController *)vc completion:(void (^)(void))completion;
+ (void)hideAuthIn:(UIViewController *)vc completion:(void (^)(void))completion;

+ (void)showAuthIn:(UIViewController *)vc withRootViewController:(UIViewController *)rootViewController completion:(void (^)(void))completion;

// 授权成功
- (void)authorizationWasSucceed;
// 授权失败
- (void)authorizationWasFailed;
// 授权过期
- (void)authorizationWasInvalid;
// 用户取消授权
- (void)authorizationWasCancelled;

@end
