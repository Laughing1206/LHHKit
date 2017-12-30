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

NSInteger const DefaultVisibleCount = 4;
CGFloat   const DefaultArrowButtonWidth = 50.f;

#import "ScrollPageTopView.h"
#import "ScrollPageTopCell.h"
#import "UICollectionViewDefaultLeftLayout.h"

@interface ScrollPageTopView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray * viewsArray;
@property (nonatomic, strong) NSMutableArray * pageModels;
@property (nonatomic, strong) NSMutableArray * tabButtons;
@property (nonatomic, strong) NSMutableArray * tabRedDots; //按钮上的红点

@property (nonatomic, assign) NSInteger continueDraggingNumber;
@property (nonatomic, assign) NSInteger currentTabSelected;
@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, assign) CGFloat selectedLineOffsetXBeforeMoving;

@property (nonatomic, assign) BOOL isBuildUI;
@property (nonatomic, assign) BOOL isUseDragging; //是否使用手拖动的，自动的就设置为NO
@property (nonatomic, assign) BOOL isEndDecelerating;

@property (nonatomic, strong) UIView * tabSelectedLine;
@property (nonatomic, strong) UIView * selectedLine;
@property (nonatomic, strong) UIView * shadowLine;
@property (nonatomic, strong) UIView * verticalLine;
@property (nonatomic, strong) UIButton * arrowButton;
@property (nonatomic, strong) UIButton * bgButton;
@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation ScrollPageTopView

- (void)buildUI
{
    _isBuildUI = NO;
    _isUseDragging = NO;
    _isEndDecelerating = YES;
    _startOffsetX = 0;
    _continueDraggingNumber = 0;
    
    NSInteger number = [self.delegate numberOfPagers:self];
    [self.pageModels removeAllObjects];
    for (int i = 0; i < number; i++)
    {
        //ScrollView部分
        UIViewController * viewController = [self.delegate pagerViewOfPagers:self indexOfPagers:i];
        [self.viewsArray addObject:viewController];
        [self.bodyScrollView addSubview:viewController.view];
        
        //tab上按钮
        UIButton * itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat itemButtonWidth = number > DefaultVisibleCount ? self.tabScrollView.width / DefaultVisibleCount : self.tabScrollView.width / number;
        itemButton.backgroundColor = [UIColor whiteColor];
        itemButton.frame = CGRectMake(itemButtonWidth * i, 0, itemButtonWidth, self.tabFrameHeight);
        [itemButton.titleLabel setFont:self.tabButtonFontSize];
        [itemButton setTitle:viewController.navigationItem.title forState:UIControlStateNormal];
        [itemButton setTitleColor:self.tabButtonTitleColorForNormal forState:UIControlStateNormal];
        [itemButton setTitleColor:self.tabButtonTitleColorForSelected forState:UIControlStateSelected];
        [itemButton addTarget:self action:@selector(onTabButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = i;
        [self.tabButtons addObject:itemButton];
        [self.tabScrollView addSubview:itemButton];
        
        //tab上的红点
        UIView * aRedDot = [[UIView alloc] initWithFrame:CGRectMake(itemButton.width / 2 + [self buttonTitleRealSize:itemButton].width / 2 + 3, itemButton.height / 2 - [self buttonTitleRealSize:itemButton].height / 2, 8, 8)];
        aRedDot.backgroundColor     = [UIColor redColor];
        aRedDot.layer.cornerRadius  = aRedDot.width/2.0f;
        aRedDot.layer.masksToBounds = YES;
        aRedDot.hidden = YES;
        [self.tabRedDots addObject:aRedDot];
        [itemButton addSubview:aRedDot];
        
        ScrollPageModel * model = [[ScrollPageModel alloc] init];
        model.title = viewController.navigationItem.title?:@"无";
        if (i == 0)
        {
            model.isSelected = YES;
        }
        else
        {
            model.isSelected = NO;
        }
        [self.pageModels addObject:model];
    }
    //tabView
    self.tabScrollView.backgroundColor = self.tabBackgroundColor;
    [self.tabView addSubview:self.arrowButton];
    [self.tabView addSubview:self.verticalLine];
    [self.tabView addSubview:self.shadowLine];
    [self.tabView addSubview:self.bgButton];
    [self.tabView addSubview:self.collectionView];
    
    self.tabScrollView.contentSize = CGSizeMake((self.tabButtons.count > DefaultVisibleCount ? self.tabScrollView.width / DefaultVisibleCount : self.tabScrollView.width / self.tabButtons.count) * self.tabButtons.count, 0);
    
    _isBuildUI = YES;
    [self setNeedsLayout];
}

- (CGSize)buttonTitleRealSize:(UIButton *)button
{
    CGSize size = CGSizeZero;
    size = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    return size;
}

- (void)layoutSubviews
{
    if (_isBuildUI)
    {
        CGFloat cellHeight = 15.f;
        
        cellHeight += [ScrollPageTopCell returnCellSize].height * ceil(self.pageModels.count / 3.f);
        
        cellHeight += (ceil(self.pageModels.count / 3.f) - 1) * 10.f;
        
        cellHeight += 15.f;
        
        if (cellHeight >= self.bodyScrollView.height)
        {
            cellHeight = self.bodyScrollView.height;
        }
        self.collectionView.frame = CGRectMake(self.bgButton.left, self.bgButton.top, self.bgButton.width, cellHeight);
        self.bodyScrollView.contentSize = CGSizeMake(self.width * self.viewsArray.count, 0);
        self.tabScrollView.contentSize = CGSizeMake((self.tabButtons.count > DefaultVisibleCount ? self.tabScrollView.width / DefaultVisibleCount : self.tabScrollView.width / self.tabButtons.count) * self.tabButtons.count, 0);
        for (int i = 0; i < [self.viewsArray count]; i++)
        {
            UIViewController * viewController = self.viewsArray[i];
            viewController.view.frame = CGRectMake(self.bodyScrollView.width * i, 0, self.bodyScrollView.width, self.bodyScrollView.height);
        }
    }
    [super layoutSubviews];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pageModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScrollPageTopCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScrollPageTopCell" forIndexPath:indexPath];
    
    cell.model = [self.pageModels safeObjectAtIndex:indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateAlignedLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [ScrollPageTopCell returnCellSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 22.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15.f, 15.f, 15.f, 15.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.arrowButton.selected = NO;
    [self setupTabViewFrameArrowButtonSelect:NO];
    
    [self setupScrollPageModelSelect:indexPath.item];
    
    [self selectTabWithIndex:indexPath.item animate:YES];
}

#pragma mark - Button Action
- (void)arrowButtonSelected:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self setupTabViewFrameArrowButtonSelect:sender.selected];
}

- (void)bgButtonSelected:(UIButton *)sender
{
    self.arrowButton.selected = NO;
    [self setupTabViewFrameArrowButtonSelect:NO];
}

- (void)onTabButtonSelected:(UIButton *)sender
{
    [self selectTabWithIndex:sender.tag animate:YES];
}

- (void)selectTabWithIndex:(NSInteger)index animate:(BOOL)isAnimate
{
    UIButton * preButton = [self.tabButtons safeObjectAtIndex:self.currentTabSelected];
    preButton.selected = NO;
    UIButton * currentButton = [self.tabButtons safeObjectAtIndex:index];
    currentButton.selected = YES;
    _currentTabSelected = index;
    
    void(^moveSelectedLine)(void) = ^(void) {
        self.selectedLine.center = CGPointMake(currentButton.center.x, self.selectedLine.center.y);
        self.selectedLineOffsetXBeforeMoving = self.selectedLine.origin.x;
    };
    
    //移动select line
    if (isAnimate)
    {
        [UIView animateWithDuration:0.3 animations:^ {
            moveSelectedLine();
        }];
    }
    else
    {
        moveSelectedLine();
    }
    
    if (currentButton.center.x - (self.tabViewWidth - DefaultArrowButtonWidth) / 2.f < 0)
    {
        [self.tabScrollView setContentOffset:CGPointMake(0, 0) animated:isAnimate];
    }
    else if (currentButton.center.x + (self.tabViewWidth - DefaultArrowButtonWidth) / 2.f  > self.tabScrollView.contentSize.width)
    {
        
        [self.tabScrollView setContentOffset:CGPointMake(self.tabScrollView.contentSize.width - self.tabViewWidth + DefaultArrowButtonWidth, 0) animated:isAnimate];
    }
    else
    {
        [self.tabScrollView setContentOffset:CGPointMake(currentButton.center.x - (self.tabViewWidth - DefaultArrowButtonWidth) / 2.f, 0) animated:isAnimate];
    }

    
    [self switchWithIndex:index animate:isAnimate];
    
    if ( self.whenSelectOnPager )
    {
        self.whenSelectOnPager(index);
    }

    [self hideRedDotWithIndex:index];
    
    [self setupScrollPageModelSelect:index];
}

- (void)setupTabViewFrameArrowButtonSelect:(BOOL)isSelected
{
    if (isSelected)
    {
        self.tabView.frame = CGRectMake(0, 0, self.tabViewWidth, self.tabFrameHeight + self.bodyScrollView.height);
    }
    else
    {
        self.tabView.frame = CGRectMake(0, 0, self.tabViewWidth, self.tabFrameHeight);
    }

}

- (void)setupScrollPageModelSelect:(NSInteger)index
{
    for (ScrollPageModel * model in self.pageModels)
    {
        model.isSelected = NO;
    }
    ScrollPageModel * model = [self.pageModels safeObjectAtIndex:index];
    model.isSelected = YES;
    [self.collectionView reloadData];
}

/**
 *  Selected Line跟随移动
 */
- (void)moveSelectedLineByScrollWithOffsetX:(CGFloat)offsetX
{
    CGFloat textGap = (self.width - self.tabMargin * 2 - self.selectedLine.width * self.tabButtons.count) / (self.tabButtons.count * 2);
    CGFloat speed = 50;
    //移动的距离
    CGFloat movedFloat = self.selectedLineOffsetXBeforeMoving + (offsetX * (textGap + self.selectedLine.width + speed)) / [UIScreen mainScreen].bounds.size.width;
    //最大右移值
    CGFloat selectedLineRightBarrier = _selectedLineOffsetXBeforeMoving + textGap * 2 + self.selectedLine.width;
    //最大左移值
    CGFloat selectedLineLeftBarrier = _selectedLineOffsetXBeforeMoving - textGap * 2 - self.selectedLine.width;
    CGFloat selectedLineNewX = 0;
    
    //连续拖动时的处理
    BOOL isContinueDragging = NO;
    if (_continueDraggingNumber > 1)
    {
        isContinueDragging = YES;
    }
    
    if (movedFloat > selectedLineRightBarrier && !isContinueDragging)
    {
        //右慢拖动设置拦截
        selectedLineNewX = selectedLineRightBarrier;
    }
    else if (movedFloat < selectedLineLeftBarrier && !isContinueDragging)
    {
        //左慢拖动设置的拦截
        selectedLineNewX = selectedLineLeftBarrier;
    }
    else
    {
        //连续拖动可能超过总长的情况需要拦截
        if (isContinueDragging)
        {
            if (movedFloat > self.width - (self.tabMargin + textGap + self.selectedLine.width))
            {
                selectedLineNewX = self.width - (self.tabMargin + textGap + self.selectedLine.width);
            }
            else if (movedFloat < self.tabMargin + textGap)
            {
                selectedLineNewX = self.tabMargin + textGap;
            }
            else
            {
                selectedLineNewX = movedFloat;
            }
        }
        else
        {
            //无拦截移动
            selectedLineNewX = movedFloat;
        }
    }
}

/**
 *  红点隐藏显示
 */
- (void)showRedDotWithIndex:(NSInteger)index
{
    UIView * redDot = [self.tabRedDots safeObjectAtIndex:index];
    redDot.hidden = NO;
}

- (void)hideRedDotWithIndex:(NSInteger)index
{
    UIView * redDot = [self.tabRedDots safeObjectAtIndex:index];
    redDot.hidden = YES;
}

#pragma mark - BodyScrollView
- (void)switchWithIndex:(NSInteger)index animate:(BOOL)isAnimate
{
    [self.bodyScrollView setContentOffset:CGPointMake(index * self.width, 0) animated:isAnimate];
    _isUseDragging = NO;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.bodyScrollView)
    {
        _continueDraggingNumber += 1;
        if (_isEndDecelerating)
        {
            _startOffsetX = scrollView.contentOffset.x;
        }
        _isUseDragging = YES;
        _isEndDecelerating = NO;
    }
}

/**
 *  对拖动过程中的处理
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.bodyScrollView)
    {
        CGFloat movingOffsetX = scrollView.contentOffset.x - _startOffsetX;
        if (_isUseDragging)
        {
            //tab处理事件待完成
            [self moveSelectedLineByScrollWithOffsetX:movingOffsetX];
        }
    }
}

/**
 *  手释放后pager归位后的处理
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.bodyScrollView)
    {
        [self selectTabWithIndex:(int)scrollView.contentOffset.x/self.bounds.size.width animate:YES];
        
        _isUseDragging = YES;
        _isEndDecelerating = YES;
        _continueDraggingNumber = 0;
    }
}
/**
 *  自动停止
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.bodyScrollView)
    {
        //tab处理事件待完成
        [self selectTabWithIndex:(int)scrollView.contentOffset.x/self.bounds.size.width animate:YES];
    }
}

#pragma mark - Setter/Getter
/**
 *  头部tab
 */
- (UIScrollView *)tabScrollView
{
    if (!_tabScrollView)
    {
        _tabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.tabViewWidth - DefaultArrowButtonWidth, self.tabFrameHeight )];
        _tabScrollView.backgroundColor = [UIColor whiteColor];
        _tabScrollView.delegate = self;
        _tabScrollView.userInteractionEnabled = YES;
        _tabScrollView.bounces = NO;
        _tabScrollView.showsHorizontalScrollIndicator = NO;
        [self.tabView addSubview:_tabScrollView];
    }
    return _tabScrollView;
}

- (UIView *)tabView
{
    if (!_tabView)
    {
        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabViewWidth, self.tabFrameHeight)];
        _tabView.backgroundColor = [UIColor clearColor];
        _tabView.clipsToBounds = YES;
    }
    return _tabView;
}

- (NSMutableArray *)pageModels
{
    if (!_pageModels)
    {
        _pageModels = [[NSMutableArray alloc] init];
    }
    return _pageModels;
}

- (NSMutableArray *)tabButtons
{
    if (!_tabButtons)
    {
        _tabButtons = [[NSMutableArray alloc] init];
    }
    return _tabButtons;
}

- (NSMutableArray *)tabRedDots
{
    if (!_tabRedDots)
    {
        _tabRedDots = [[NSMutableArray alloc] init];
    }
    return _tabRedDots;
}

- (CGFloat)tabFrameHeight
{
    if (!_tabFrameHeight)
    {
        _tabFrameHeight = 35.f;
    }
    return _tabFrameHeight;
}

- (CGFloat)tabMargin
{
    if (!_tabMargin)
    {
        _tabMargin = 38;
    }
    return _tabMargin;
}

- (NSInteger)currentTabSelected
{
    if (!_currentTabSelected)
    {
        _currentTabSelected = 0;
    }
    return _currentTabSelected;
}

- (UIColor *)tabBackgroundColor
{
    if (!_tabBackgroundColor)
    {
        _tabBackgroundColor = [UIColor whiteColor];
    }
    return _tabBackgroundColor;
}

- (UIFont *)tabButtonFontSize
{
    if (!_tabButtonFontSize)
    {
        _tabButtonFontSize = [UIFont systemFontOfSize:15.f];
    }
    return _tabButtonFontSize;
}

- (CGFloat)tabViewWidth
{
    if (!_tabViewWidth)
    {
        _tabViewWidth = self.width;
    }
    return _tabViewWidth;
}

- (UIColor *)tabButtonTitleColorForNormal
{
    if (!_tabButtonTitleColorForNormal)
    {
        _tabButtonTitleColorForNormal = [UIColor colorWithHexString:@"55595F"];
    }
    return _tabButtonTitleColorForNormal;
}

- (UIColor *)tabButtonTitleColorForSelected
{
    if (!_tabButtonTitleColorForSelected)
    {
        _tabButtonTitleColorForSelected = [UIColor colorWithHexString:@"404245"];
    }
    return _tabButtonTitleColorForSelected;
}

- (UIView *)selectedLine
{
    if (!_selectedLine)
    {
        _selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabView.height - 2, self.selectedLineWidth, 2)];
        _selectedLine.backgroundColor = [UIColor colorWithHexString:@"F46C18"];
        [self.tabScrollView addSubview:_selectedLine];
    }
    return _selectedLine;
}

- (UIView *)shadowLine
{
    if (!_shadowLine)
    {
        _shadowLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabFrameHeight - 1, self.tabView.width, 1)];
        _shadowLine.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    }
    return _shadowLine;
}

- (UIView *)verticalLine
{
    if (!_verticalLine)
    {
        _verticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.arrowButton.left, 8.f, 1.f, self.tabFrameHeight - 16.f)];
        _verticalLine.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    }
    return _verticalLine;
}

- (UIButton *)arrowButton
{
    if (!_arrowButton)
    {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrowButton.backgroundColor = [UIColor whiteColor];
        _arrowButton.frame = CGRectMake(self.tabView.width - DefaultArrowButtonWidth, 0, DefaultArrowButtonWidth, self.tabFrameHeight);
        [_arrowButton setImage:[UIImage imageNamed:@"list_arrow_down"] forState:UIControlStateNormal];
        [_arrowButton setImage:[UIImage imageNamed:@"list_arrow_up"] forState:UIControlStateSelected];
        [_arrowButton addTarget:self action:@selector(arrowButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowButton;
}

- (UIButton *)bgButton
{
    if (!_bgButton)
    {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _bgButton.frame = CGRectMake(0, self.tabFrameHeight, self.tabView.width, self.bodyScrollView.height);
        [_bgButton addTarget:self action:@selector(bgButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewDefaultLeftLayout * layout = [[UICollectionViewDefaultLeftLayout alloc] init];
        layout.maximumInteritemSpacing = 22.f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[ScrollPageTopCell class] forCellWithReuseIdentifier:@"ScrollPageTopCell"];
    }
    return _collectionView;
}

- (CGFloat)selectedLineWidth
{
    if (!_selectedLineWidth)
    {
        _selectedLineWidth = 19.f;
    }
    return _selectedLineWidth;
}

- (CGFloat)selectedLineOffsetXBeforeMoving
{
    if (!_selectedLineOffsetXBeforeMoving)
    {
        _selectedLineOffsetXBeforeMoving = 0;
    }
    return _selectedLineOffsetXBeforeMoving;
}

/**
 *  滑动pager主体
 */
- (UIScrollView*)bodyScrollView
{
    if (!_bodyScrollView)
    {
        _bodyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height )];
        _bodyScrollView.delegate = self;
        _bodyScrollView.pagingEnabled = YES;
        _bodyScrollView.userInteractionEnabled = YES;
        _bodyScrollView.bounces = NO;
        _bodyScrollView.showsHorizontalScrollIndicator = NO;
        _bodyScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_bodyScrollView];
    }
    return _bodyScrollView;
}

- (NSMutableArray *)viewsArray
{
    if (!_viewsArray)
    {
        _viewsArray = [[NSMutableArray alloc] init];
    }
    return _viewsArray;
}

@end


