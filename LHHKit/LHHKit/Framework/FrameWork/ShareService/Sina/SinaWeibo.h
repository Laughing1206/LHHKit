//
//  RenRenCiShanJia
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceShare.h"
#import "WeiboSDK.h"

@interface SinaWeibo : ServiceShare <WeiboSDKDelegate, WBHttpRequestDelegate>

SingletonInterface(SinaWeibo)

@property (nonatomic, copy) NSString * authCode;
@property (nonatomic, copy) NSString * accessToken;
@property (nonatomic, copy) NSString * expiresIn;
@property (nonatomic, copy) NSString * remindIn;
@property (nonatomic, copy) NSString * uid;

@property (nonatomic, readonly) BOOL isExpired;

- (void)share;
+ (BOOL)isWeiboAppInstalled;
- (void)followWithName:(NSString *)name;

- (void)getUserInfo;

@end
