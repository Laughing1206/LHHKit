//  MJRefreshLegendFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/5.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MJRefreshLegendFooter.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"

@interface MJRefreshLegendFooter()
//@property (nonatomic, weak) UIImageView *activityImage;
@property (nonatomic, weak) UIImageView *activityView;
@end

@implementation MJRefreshLegendFooter
#pragma mark - 懒加载
- (UIImageView *)activityView
{
    if (!_activityView) {
        
        UIImageView * activityView = [[UIImageView alloc] init];
        activityView.contentMode = UIViewContentModeCenter;
        
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:56];
        for (NSInteger i = 0; i < 56; i++)
        {
            [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"mj_resources.bundle/mj_pull down_000%02ld",(long)i]]];
        }
        activityView.animationImages = imageArray;
        activityView.animationDuration = 1.0;
        activityView.animationRepeatCount = 0;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}

#pragma mark - 初始化方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.activityView.frame = self.bounds;
    self.activityView.centerX = self.width / 2;
}

#pragma mark - 公共方法
- (void)setState:(MJRefreshFooterState)state
{
    if (self.state == state) return;
    
    switch (state) {
        case MJRefreshFooterStateIdle:
            [self.activityView stopAnimating];
            break;
            
        case MJRefreshFooterStateRefreshing:
            [self.activityView startAnimating];
            break;
            
        case MJRefreshFooterStateNoMoreData:
            [self.activityView stopAnimating];
            break;
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

@end
