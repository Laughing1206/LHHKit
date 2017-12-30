//
//  NSTimer+addition.h
//  YJWebProgressLayer
//
//  Created by Kean on 2016/12/15.
//  Copyright © 2016年 Kean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (addition)

- (void)pauseTime;    // 暂停时间
- (void)webPageTime;  // 获取内容所在当前时间
- (void)webPageTimeWithTimeInterval:(NSTimeInterval)time;  // 当前时间 time 秒后的时间

@end
