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

#import "ServiceAlipay.h"
#import "Order.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import <AlipaySDK/AlipaySDK.h>

#pragma mark -

NSString * const AlipaySucceedNotification = @"AlipaySucceedNotification";
NSString * const AlipayFailedNotification = @"AlipayFailedNotification";
NSString * const AlipayCanceledNotification = @"AlipayCanceledNotification";
NSString * const AlipayProcessingNotification = @"AlipayProcessingNotification";

#pragma mark -

@implementation ServiceAlipay

SingletonImplemention(ServiceAlipay)

#pragma mark -

+ (void)load
{
    [AppService addService:[self sharedServiceAlipay]];
}

#pragma mark -

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
//                                                      NSLog(@"result = %@",resultDic);
                                                  }];
    }
    return YES;
}

#pragma mark -

- (ServiceAlipayConfig *)config
{
    return [ServiceAlipayConfig sharedServiceAlipayConfig];
}

#pragma mark -

- (ServiceBlock)PAY
{
    ServiceBlock block = ^ void ( void )
    {
        [self pay];
    };
    
    return [block copy];
}

#pragma mark -

- (void)pay
{

    NSString * appScheme = [self urlSchemaWithName:@"alipay"];

    //将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString * orderString = self.config.order_string;

	[[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {

		// 通知返回时验证签名
		NSNumber * resultStatus = resultDic[@"resultStatus"];
//		NSString * resultStr = resultDic[@"result"];

//		NSString * successStr = [NSString stringWithFormat:@"success=%@", @"true"]; // success="true"
//		BOOL success; // result中是否包含success="true"

		if ( resultStatus.intValue == 9000 )
		{
			[self notifySucceed];

//			if ( resultStr && resultStr.length )
//			{
//				NSRange range = [resultStr rangeOfString:successStr];
//
//				if ( range.length == [successStr length] )
//				{
//					success = YES;
//				}
//				else
//				{
//					success = NO;
//				}
//				
//				if ( success )
//				{
//					[self notifySucceed];
//				}
//				else
//				{
//					[self notifyFailed];
//				}
//			}
		}
		else if ( resultStatus.intValue == 8000 )
		{
			[self notifyProcessing];
		}
		else if ( resultStatus.intValue == 6001 )
		{
			[self notifyCanceled];
		}
		else
		{
			[self notifyFailed];
		}
	}];
}

#pragma mark -

- (void)notifySucceed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AlipaySucceedNotification object:nil];
    
    if ( self.whenSucceed )
    {
        self.whenSucceed();
    }
}

- (void)notifyFailed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AlipayFailedNotification object:nil];
    
    if ( self.whenFailed )
    {
        self.whenFailed();
    }
}

- (void)notifyCanceled
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AlipayCanceledNotification object:nil];
    
    if ( self.whenCancel )
    {
        self.whenCancel();
    }
}

- (void)notifyProcessing
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AlipayProcessingNotification object:nil];
    
    if ( self.whenWaiting )
    {
        self.whenWaiting();
    }
}

- (NSString *)urlSchemaWithName:(NSString *)name
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for ( NSDictionary * dict in array )
    {
        if ( name )
        {
            NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
            if ( nil == URLName )
            {
                continue;
            }
            
            if ( NO == [URLName isEqualToString:name] )
            {
                continue;
            }
        }
        
        NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        if ( nil == URLSchemes || 0 == URLSchemes.count )
        {
            continue;
        }
        
        NSString * schema = [URLSchemes objectAtIndex:0];
        if ( schema && schema.length )
        {
            return schema;
        }
    }
    
    return nil;
    
#else
    
    return nil;
    
#endif
}


@end
