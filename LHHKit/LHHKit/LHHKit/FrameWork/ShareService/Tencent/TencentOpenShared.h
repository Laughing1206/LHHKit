//
//  RenRenCiShanJia
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//


#import "ServiceShare.h"
#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/TencentOAuthObject.h>
//#import <TencentOpenAPI/TencentMessageObject.h>
//#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

typedef NS_ENUM(NSUInteger, TencentOpenSence) {
	TencentOpenSenceQQ,
	TencentOpenSenceQZone
};

@interface TencentOpenShared : ServiceShare <TencentSessionDelegate, QQApiInterfaceDelegate,TencentLoginDelegate>

SingletonInterface(TencentOpenShared)

@property (nonatomic, retain) TencentOAuth *                tencentOAuth;
@property (nonatomic, strong) NSDictionary *				responseDic;

- (void)shareQq;
- (void)shareQzone;

+ (BOOL)isTencentAppInstalled;

- (void)getUserInfo;

@end
