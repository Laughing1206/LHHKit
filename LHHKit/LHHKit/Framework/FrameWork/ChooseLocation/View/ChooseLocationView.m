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

#import "ChooseLocationView.h"
#import "AddressView.h"
#import "AddressTableViewCell.h"
#import "CityTool.h"

static CGFloat const kTopViewHeight = 40; //顶部视图的高度
static CGFloat const kTopTabbarHeight = 30; //地址标签栏的高度

@interface ChooseLocationView () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) AddressView * topTabbar;
@property (nonatomic, weak) UIScrollView * contentView;
@property (nonatomic, weak) UIView * underLine;
@property (nonatomic, strong) NSArray * provinceSouce;
@property (nonatomic, strong) NSArray * citySouce;
@property (nonatomic, strong) NSArray * areaSouce;
@property (nonatomic, strong) NSMutableArray * tableViews;
@property (nonatomic, strong) NSMutableArray * topTabbarItems;
@property (nonatomic, weak) UIButton * selectedBtn;
@end

@implementation ChooseLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
    }
    return self;
}

#pragma mark - setUp UI

- (void)setupUI
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kTopViewHeight)];
    [self addSubview:topView];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"选择您所在地区";
    titleLabel.textColor = [UIColor colorWithHexString:@"1F1F1F"];
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.centerY = topView.height * 0.5;
    titleLabel.centerX = topView.width * 0.5;
    UIView * separateLine = [self separateLine];
    [topView addSubview: separateLine];
    separateLine.top = topView.height - separateLine.height;
    topView.backgroundColor = [UIColor whiteColor];

    AddressView * topTabbar = [[AddressView alloc]initWithFrame:CGRectMake(0, topView.height, self.frame.size.width, kTopViewHeight)];
    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    [self addTopBarItem];
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.top = topTabbar.height - separateLine.height;
    [_topTabbar layoutIfNeeded];
    topTabbar.backgroundColor = [UIColor whiteColor];
    
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.height = 2.0f;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.top = separateLine1.top - underLine.height;
    
    _underLine.backgroundColor = [UIColor orangeColor];
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - kTopViewHeight - kTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(kscreen_width, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addTableView];
    _contentView.delegate = self;
}

- (void)addTableView
{
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * kscreen_width, 0, kscreen_width, _contentView.height)];
    [_contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [tabbleView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
}

- (void)addTopBarItem
{
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
    topBarItem.titleLabel.font = [UIFont systemFontOfSize:14];
    [topBarItem setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [topBarItem sizeToFit];
     topBarItem.centerY = _topTabbar.height * 0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topTabbar addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - TableViewDatasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        return self.provinceSouce.count;
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        return self.citySouce.count;
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        return self.areaSouce.count;
    }
    return self.provinceSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id model = nil;
    //省级别
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        model = self.provinceSouce[indexPath.row];
    //市级别
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        model = self.citySouce[indexPath.row];
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        model = self.areaSouce[indexPath.row];
    }
    cell.model = model;
    return cell;
}

#pragma mark - TableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        //1.1 获取下一级别的数据源(市级别,如果是直辖市时,下级则为区级别)
        ProvinceItem * provinceItem = self.provinceSouce[indexPath.row];
        self.citySouce = provinceItem.cities;
        if(self.citySouce.count == 0)
        {
            for (NSInteger i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++)
            {
                [self removeLastItem];
            }
            [self setupAddress:provinceItem.name];
            return indexPath;
        }
        //1.1 判断是否是第一次选择,不是,则重新选择省,切换省.
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];

        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0)
        {
            for (NSInteger i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++)
            {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:provinceItem.name];
            return indexPath;
            
        }
        else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0)
        {
            for (NSInteger i = 0; i < self.tableViews.count && self.tableViews.count != 1 ; i++)
            {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:provinceItem.name];
            return indexPath;
        }

        //之前未选中省，第一次选择省
        [self addTopBarItem];
        [self addTableView];
        
        [self scrollToNextItem:provinceItem.name];
        
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        CityItem * cityItem = self.citySouce[indexPath.row];
        self.areaSouce = cityItem.areas;
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0)
        {
            for (NSInteger i = 0; i < self.tableViews.count - 1; i++)
            {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:cityItem.name];
            return indexPath;
            
        } else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0) {
            
            [self scrollToNextItem:cityItem.name];
            return indexPath;
        }
        
        [self addTopBarItem];
        [self addTableView];
        [self scrollToNextItem:cityItem.name];
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        AreaItem * areaItem = self.areaSouce[indexPath.row];
        [self setupAddress:areaItem.name];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        ProvinceItem * provinceItem = self.provinceSouce[indexPath.row];
        provinceItem.isSelected = YES;
        for (CityItem * cityItem in provinceItem.cities)
        {
            cityItem.isSelected = NO;
            for (AreaItem * areaItem in cityItem.areas)
            {
                areaItem.isSelected = NO;
            }
        }
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        CityItem * cityItem = self.citySouce[indexPath.row];
        cityItem.isSelected = YES;
        for (AreaItem * areaItem in cityItem.areas)
        {
            areaItem.isSelected = NO;
        }
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        AreaItem * areaItem = self.areaSouce[indexPath.row];
        areaItem.isSelected = YES;
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        ProvinceItem * provinceItem = self.provinceSouce[indexPath.row];
        provinceItem.isSelected = NO;
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        CityItem * cityItem = self.citySouce[indexPath.row];
        cityItem.isSelected = NO;
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        AreaItem * areaItem = self.areaSouce[indexPath.row];
        areaItem.isSelected = NO;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - private
//点击按钮,滚动到对应位置
- (void)topBarItemClick:(UIButton *)btn
{
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * kscreen_width, 0);
        [self changeUnderLineFrame:btn];
    }];
}

//调整指示条位置
- (void)changeUnderLineFrame:(UIButton *)btn
{
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    _underLine.left = btn.left;
    _underLine.width = btn.width;
}

//完成地址选择,执行chooseFinish代码块
- (void)setupAddress:(NSString *)address
{
    NSInteger index = self.contentView.contentOffset.x / kscreen_width;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:address forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [self changeUnderLineFrame:btn];
    NSMutableArray * addressArray = [[NSMutableArray alloc] init];
    [addressArray removeAllObjects];
    for (UIButton * btn  in self.topTabbarItems)
    {
        [addressArray addObject:btn.currentTitle];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.chooseFinish) {
            self.chooseFinish(addressArray);
        }
    });
}

//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem
{
    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle
{
    NSInteger index = self.contentView.contentOffset.x / kscreen_width;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.contentSize = (CGSize){self.tableViews.count * kscreen_width,0};
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + kscreen_width, offset.y);
        [self changeUnderLineFrame: [self.topTabbar.subviews lastObject]];
    }];
}

#pragma mark - <UIScrollView>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView != self.contentView) return;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger index = scrollView.contentOffset.x / kscreen_width;
        UIButton * btn = weakSelf.topTabbarItems[index];
        [weakSelf changeUnderLineFrame:btn];
    }];
}

#pragma mark - getter 方法

//分割线
- (UIView *)separateLine
{
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
    separateLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    return separateLine;
}

- (NSMutableArray *)tableViews
{
    if (_tableViews == nil)
    {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)topTabbarItems
{
    if (_topTabbarItems == nil)
    {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}


//省级别数据源
- (NSArray *)provinceSouce
{
    if (_provinceSouce == nil)
    {
        _provinceSouce = [CityTool getProvinces];
    }
    return _provinceSouce;
}
@end
