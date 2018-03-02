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

#import "Authorization.h"
//#import "SigninController.h"

NSString *const AuthorizationWasFailedNotification    = @"AuthorizationWasFailedNotification";
NSString *const AuthorizationWasSucceedNotification   = @"AuthorizationWasSucceedNotification";
NSString *const AuthorizationWasInvalidNotification   = @"AuthorizationWasInvalidNotification";
NSString *const AuthorizationWasCancelledNotification = @"AuthorizationWasCancelledNotification";

@interface Authorization(Private)
+ (void)showAuthIn:(UIViewController *)vc completion:(void (^)(void))completion;
+ (void)hideAuthIn:(UIViewController *)vc completion:(void (^)(void))completion;
@end

@implementation Authorization

SingletonImplemention(Authorization)

- (void)showAuth
{
    [self showAuthWithCompletion:nil];
}

- (void)hideAuth
{
    [self hideAuthWithCompletion:nil];
}

- (void)showAuthWithCompletion:(void (^)(void))completion
{
    [[self class] showAuthIn:self.delegate completion:completion];
}

- (void)hideAuthWithCompletion:(void (^)(void))completion
{
    [[self class] hideAuthIn:self.delegate completion:completion];
}

+ (void)showAuthIn:(UIViewController *)vc completion:(void (^)(void))completion
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
//        UINavigationController * auth = \
//        [[UINavigationController alloc] initWithRootViewController:[SigninController spawn]];
//        UIPopoverController * pop = [[UIPopoverController alloc] initWithContentViewController:auth];
//        [pop presentPopoverFromRect:vc.view.frame
//                             inView:vc.view
//           permittedArrowDirections:0
//                           animated:YES];
        PERFORM_BLOCK_SAFELY(completion);
    }
    else
    {
        // TODO: 判断是否有授权界面已经显示
//        UINavigationController * auth = \
//        [[UINavigationController alloc] initWithRootViewController:[SigninController spawn]];
//        [vc presentViewController:auth animated:YES completion:completion];
    }
}

+ (void)hideAuthIn:(UIViewController *)vc completion:(void (^)(void))completion
{
    // TODO: 判断是否有授权界面已经显示
    [vc dismissViewControllerAnimated:YES completion:completion];
}

+ (void)showAuthIn:(UIViewController *)vc withRootViewController:(UIViewController *)rootViewController completion:(void (^)(void))completion
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UINavigationController * auth = \
        [[UINavigationController alloc] initWithRootViewController:rootViewController];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIPopoverController * pop = [[UIPopoverController alloc] initWithContentViewController:auth];
        [pop presentPopoverFromRect:vc.view.frame
                             inView:vc.view
           permittedArrowDirections:0
                           animated:YES];
        PERFORM_BLOCK_SAFELY(completion);
    }
    else
    {
        // TODO: 判断是否有授权界面已经显示
        UINavigationController * auth = \
        [[UINavigationController alloc] initWithRootViewController:rootViewController];
        [vc presentViewController:auth animated:YES completion:completion];
    }
#pragma clang diagnostic pop
}

#pragma mark -

- (void)authorizationWasSucceed
{
    if ( self.delegate &&
        [self.delegate respondsToSelector:@selector(authorizationWasSucceed)] )
    {
        [self.delegate authorizationWasSucceed];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AuthorizationWasSucceedNotification object:nil];
}

- (void)authorizationWasFailed
{
    if ( self.delegate &&
        [self.delegate respondsToSelector:@selector(authorizationWasFailed)] )
    {
        [self.delegate authorizationWasFailed];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AuthorizationWasFailedNotification object:nil];
}

- (void)authorizationWasInvalid
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AuthorizationWasInvalidNotification object:nil];
}

- (void)authorizationWasCancelled
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AuthorizationWasCancelledNotification object:nil];
}

@end
