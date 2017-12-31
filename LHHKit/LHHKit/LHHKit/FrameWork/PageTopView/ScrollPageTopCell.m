//
//  ScrollPageTopCell.m
//  RenRenCiShanJia
//
//  Created by 李欢欢 on 2017/12/8.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//

#import "ScrollPageTopCell.h"

@implementation ScrollPageModel
@end
@interface ScrollPageTopCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation ScrollPageTopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI
{
    self.cornerRadius = 1.f;
    self.borderColor = [UIColor colorWithHexString:@"dddddd"];
    self.borderWidth = 1.f;
    
    self.titleLabel = [self addLabel:@"" Font:[UIFont systemFontOfSize:12.f] Color:[UIColor colorWithHexString:@"1f1f1f"]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

- (void)setModel:(ScrollPageModel *)model
{
    _model = model;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@", _model.title?:@"无"];
    
    if (_model.isSelected)
    {
        self.borderColor = [UIColor redColor];
        self.titleLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.borderColor = [UIColor colorWithHexString:@"dddddd"];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"1f1f1f"];
    }
}

+ (CGSize)returnCellSize
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 30.f - 2.f * 22.f) / 3.f , 30.f);
}

@end
