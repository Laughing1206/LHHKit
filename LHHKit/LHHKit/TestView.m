//
//  TestView.m
//  LHHKit
//
//  Created by 李欢欢 on 2017/11/26.
//  Copyright © 2017年 Lihuanhuan. All rights reserved.
//

#import "TestView.h"

@interface TestView()
@property (nonatomic, strong) UILabel * label;
@end

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.signal = @"test";
        
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI
{
    self.label = [self addLabel:@"我的父视图是UIView，\n但是可以点击，不信你试试" Font:[UIFont systemFontOfSize:15.f] Color:[UIColor whiteColor]];
    self.label.numberOfLines = 0;
}

- (void)setupLayout
{
    @weakify(self);
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.center.equalTo(self);
    }];
}

handleSignal(test)
{
    NSLog(@"TestView");
}

@end
