//
//  DeepLink.h
//  RenRenCiShanJia
//
//  Created by 李欢欢 on 2017/11/23.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeepLinkKit.h"

@interface DeepLink : NSObject

SingletonInterface(DeepLink)

@property (nonatomic, strong) DPLDeepLinkRouter * router;

@property (nonatomic, assign) BOOL isDeepLink;

- (BOOL)isOpenWithUrl:(NSString *)url;

- (void)powerOn;

@end
