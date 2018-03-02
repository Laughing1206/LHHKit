//
//   ___           ___        ___      ___        ___
//  /\  \         /\  \      /\  \    /\  \      /\  \
//  \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//   \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//    \ \  \______  \ \  \     \ \  \   \ \  \     \ \  \
//     \ \________\  \ \__\     \ \__\   \ \__\     \ \__\
//      \/________/   \/__/      \/__/    \/__/      \/__/
//
//  欢欢为人民服务
//  有问题请联系我，http://www.jianshu.com/u/3c6ff28fdc63
//
// -----------------------------------------------------------------------------

#import "PlaceholderView.h"

@implementation PlaceholderTableViewCell

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if ( _customView == nil )
    {
        _customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                              title:nil
                                           subtitle:@"没有符合条件的数据"
                                               tips:nil];
    }

    if ( !self.customView.superview )
    {
        [self.contentView addSubview:self.customView];
        [self.customView autoFillSuperView];
    }

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

@end

@implementation PlaceholderCollectionViewCell

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if ( _customView == nil )
    {
        _customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                              title:nil
                                           subtitle:@"没有符合条件的数据"
                                               tips:nil];
    }
    
    if ( !self.customView.superview )
    {
        [self.contentView addSubview:self.customView];
        [self.customView autoFillSuperView];
    }
    
    self.backgroundColor = [UIColor clearColor];
}

@end


@implementation PlaceholderNetWorkCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"网络连接失败，请检查网络"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

@implementation PlaceholderNetWorkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"网络连接失败，请检查网络"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

@implementation PlaceholderHomeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"暂无数据"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

@implementation PlaceholderCategoryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"暂无分类"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

@implementation PlaceholderGoodsListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"暂无商品"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

@implementation PlaceholderCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"暂无商品"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

@end

@implementation PlaceholderTradingCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"暂无交易"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

@end

@implementation PlaceholderOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"暂无订单"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

@end

@implementation PlaceholderBankCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"暂无银行卡"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

@end

@implementation PlaceholderAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"暂无地址"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

@end

@implementation PlaceholderBrowseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"暂无浏览"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

@end

@implementation PlaceholderCollectionGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"暂无关注"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

@end

@implementation PlaceholderRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.customView = [PlaceholderView viewWithIcon:[UIImage imageNamed:@"empty"]
                                                  title:@"暂无记录"
                                               subtitle:nil
                                                   tips:@"重新加载"];
        PlaceholderView * view = (PlaceholderView *)self.customView;
        
        view.titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
        view.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        view.subtitleLable.textColor = [UIColor colorWithHexString:@"999999"];
        view.subtitleLable.font = [UIFont systemFontOfSize:16.f];
        
        view.actionButton.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [view.actionButton setTitleColor:[UIColor colorWithHexString:@"BBBBBB"] forState:UIControlStateNormal];
        view.actionButton.borderColor = [UIColor colorWithHexString:@"BBBBBB"];
        view.actionButton.borderWidth = 1.f;
        view.actionButton.cornerRadius = 20.f;
        view.actionButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        self.customView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

@end
#pragma mark -

@interface PlaceholderView ()
@property (strong, nonatomic) IBOutlet UIImageView * icon;
@end

@implementation PlaceholderView

+ (instancetype)viewWithIcon:(UIImage *)image
                       title:(NSString *)title
                    subtitle:(NSString *)subtitle
                        tips:(NSString *)tips
{
    PlaceholderView * view = [PlaceholderView loadFromNib];

    view.icon.image = image;
    view.titleLabel.text = title;
    view.subtitleLable.text = subtitle;

    if ( tips && tips.length )
    {
        view.actionButton.hidden = NO;
        [view.actionButton setTitle:tips forState:UIControlStateNormal];
    }
    else
    {
        view.actionButton.hidden = YES;
        [view.actionButton setTitle:nil forState:UIControlStateNormal];
    }

    return view;
}

+ (instancetype)viewWithIcon:(UIImage *)image
                       title:(NSString *)title
                  titleColor:(UIColor *)titleColor
               titleFontSize:(NSNumber *)titleFontSize
                    subtitle:(NSString *)subtitle
               subtitleColor:(UIColor *)subtitleColor
            subtitleFontSize:(NSNumber *)subtitleFontSize
                        tips:(NSString *)tips;
{
    PlaceholderView * view = [PlaceholderView loadFromNib];
    view.icon.image = image;
    view.titleLabel.text = title;

    if ( titleColor )
    {
        view.titleLabel.textColor = titleColor;
    }
    if ( titleFontSize )
    {
        view.titleLabel.font = [UIFont systemFontOfSize:titleFontSize.floatValue];
    }
    view.subtitleLable.text = subtitle;
    if ( subtitleColor )
    {
        view.subtitleLable.textColor = subtitleColor;
    }
    if ( subtitleFontSize )
    {
        view.subtitleLable.font = [UIFont systemFontOfSize:subtitleFontSize.floatValue];
    }
    if ( tips && tips.length )
    {
        view.actionButton.hidden = NO;
        [view.actionButton setTitle:tips forState:UIControlStateNormal];
    }
    else
    {
        view.actionButton.hidden = YES;
        [view.actionButton setTitle:nil forState:UIControlStateNormal];
    }
    
    return view;
}


+ (void)registerTo:(UIScrollView *)list
{
    if ( [list isKindOfClass:UITableView.class] )
    {
        [self registerToTableView:(UITableView *)list];
    }
    else if ( [list isKindOfClass:UICollectionView.class] )
    {
        [self registerToCollectionView:(UICollectionView *)list];
    }
}

+ (void)registerToTableView:(UITableView *)tableView
{
    [tableView registerClass:PlaceholderTableViewCell.class forCellReuseIdentifier:@"PlaceholderView"];
}

+ (void)registerToCollectionView:(UICollectionView *)collectionView
{
    [collectionView registerClass:PlaceholderCollectionViewCell.class forCellWithReuseIdentifier:@"PlaceholderView"];
}

+ (id)cellForList:(id)list atIndexPath:(NSIndexPath *)indexPath
{
    if ( [list isKindOfClass:UITableView.class] )
    {
        return [list dequeueReusableCellWithIdentifier:@"PlaceholderView" forIndexPath:indexPath];
    }
    else if ( [list isKindOfClass:UICollectionView.class] )
    {
        return [list dequeueReusableCellWithReuseIdentifier:@"PlaceholderView" forIndexPath:indexPath];
    }
    return nil;
}

@end
