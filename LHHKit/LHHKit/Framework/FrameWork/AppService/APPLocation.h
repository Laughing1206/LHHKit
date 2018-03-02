//
//  APPLocation.h
//  SunnyProject
//
//  Created by 李欢欢 on 2018/1/11.
//  Copyright © 2018年 李欢欢. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPLocation : NSObject<AppService>

SingletonInterface(APPLocation)

- (void)setupLocation;
@end
