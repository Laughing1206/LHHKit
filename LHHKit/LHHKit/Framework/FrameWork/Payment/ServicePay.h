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

/*
商户系统和微信支付系统主要交互说明：
1. 用户打开商户APP客户端
2. 在商户APP客户端选择商品下单
3. 商户APP客户端向商户后台系统请求生成支付订单
4. 商户后台系统调用统一下单API，微信支付系统生成预付单
5. 微信支付系统向商户后台系统返回预付单信息
6. 商户后台系统生成带签名的客户端支付信息
7. 商户后台系统向商户APP客户端返回信息（prepay_id,sign）
8. 用户确认支付
9. 此时，商户APP客户端支付参数通过调用SDK调起微信客户端的微信支付
10. 微信客户端向微信支付系统发起支付请求，微信支付系统验证支付参数、APP支付权限等
11. 微信支付系统向微信客户端返回需要支付授权
12. 用户在微信客户端确认支付，输入密码
13. 微信客户端向微信支付系统提交支付授权，微信支付系统验证授权，完成支付交易
14. 微信支付系统向微信客户端返回支付结果，发送微信信息提示。此时，还做了并发处理：1）微信支付系统异步通知商户后台系统商户支付结果，商户后台系统接收和保存支付通知；2）商户后台系统接向微信支付系统返回告知已成功接收处理
15. 微信客户端将支付状态通过商户App客户端已实现的回调接口执行回调
16. 商户App客户端到商户后台系统查询实际支付结果
17. 商户后台系统调用微信查询API在微信支付系统查询支付结果
18. 微信支付系统向商户后台系统返回支付结果
19. 商户后台系统把支付结果返回给商户App客户端
20. 成功的话，商户就可以发货了。
*/

#import <Foundation/Foundation.h>
#import "AppService.h"

#pragma mark -

typedef	void	(^ServiceBlock)( void );
typedef	void	(^ServiceBlockN)( id first );

#pragma mark -

@interface ServicePay : NSObject <AppService>

SingletonInterface(ServicePay)

@property (nonatomic, readonly) ServiceBlock PAY;

@property (nonatomic, copy) ServiceBlock whenWaiting;
@property (nonatomic, copy) ServiceBlock whenSucceed;
@property (nonatomic, copy) ServiceBlock whenFailed;
@property (nonatomic, copy) ServiceBlock whenCancel;

- (void)powerOn;

@end
