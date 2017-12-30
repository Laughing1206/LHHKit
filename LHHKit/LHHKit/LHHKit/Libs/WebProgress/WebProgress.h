//
//  WebProgress.h
//  RenRenCiShanJia
//
//  Created by mac on 2017/11/2.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface WebProgress : CAShapeLayer
// 开始加载
- (void)startLoad;
// 完成加载
- (void)finishedLoadWithError:(NSError *)error;
// 关闭时间
- (void)closeTimer;

- (void)wkWebViewPathChanged:(CGFloat)estimatedProgress;
@end
