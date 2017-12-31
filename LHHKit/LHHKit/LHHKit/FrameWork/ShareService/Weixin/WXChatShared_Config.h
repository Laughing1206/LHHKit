//
//  RenRenCiShanJia
//
//  Created by mac on 2017/10/13.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface WXChatShared_Config : NSObject

SingletonInterface(WXChatShared_Config)

@property (nonatomic, retain) NSString *	appId;
@property (nonatomic, retain) NSString *	appKey;
@property (nonatomic, retain) NSString *	payUrl;

@end
