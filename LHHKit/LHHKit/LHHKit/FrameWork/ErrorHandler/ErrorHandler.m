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

#import "ErrorHandler.h"
#import <UIKit/UIKit.h>

@implementation ErrorHandler

+ (void)error:(id)error on:(id)container withTips:(NSString *)tips
{
    NSString * message = tips;
    NSInteger code = 200;
    
    UIView * view = nil;
    
    if ( [container isKindOfClass:UIView.class] )
    {
        view = container;
    }
    else if ( [container isKindOfClass:UIViewController.class] )
    {
        view = ((UIViewController *)container).view;
    }
    else
    {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    if ( message == nil )
    {
        if ( [error isKindOfClass:[HTTPResponseError class]] )
        {
            HTTPResponseError * e = error;
            message = e.message;
            code = e.code;
        }
        else if ( [error isKindOfClass:[NSError class]] )
        {
            // do noting
//            return;
        }
    }
    
    if ( message )
    {
        [view presentFailureTips:message];
    }
    else
    {
        [view presentFailureTips:@"网络链接失败，请重试"];
    }
}

+ (void)error:(id)error withTips:(NSString *)tips
{
    [self error:error on:nil withTips:tips];
}

+ (void)error:(id)error on:(id)container
{
    [self error:error on:container withTips:nil];
}

@end
