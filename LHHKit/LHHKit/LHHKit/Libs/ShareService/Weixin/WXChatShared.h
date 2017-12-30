//
//  RenRenCiShanJia
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//


#import "ServiceShare.h"
#import "WXApi.h"
#import "WXChatShared_Config.h"

#pragma mark -

@interface WXChatShared : ServiceShare <WXApiDelegate>

SingletonInterface(WXChatShared)

@property (nonatomic, retain) WXChatShared_Config * config;
@property (nonatomic, retain) NSString * weiXincode;
@property (nonatomic, retain) NSString * accessToken;
@property (nonatomic, retain) NSString * openid;
@property (nonatomic, retain) NSString * expiresIn;

- (void)shareFriend;
- (void)shareTimeline;

+ (BOOL)isWxAppInstalled;

- (void)getuserInfo;

@end
