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

#import "PageTopView.h"

@interface PageTopView()

@property (nonatomic, strong) NSMutableArray * viewsArray;

@property (nonatomic, assign) NSInteger continueDraggingNumber;
@property (nonatomic, assign) NSInteger currentTabSelected;
@property (nonatomic, assign) CGFloat startOffsetX;

@property (nonatomic, assign) BOOL isBuildUI;
@property (nonatomic, assign) BOOL isUseDragging; //是否使用手拖动的，自动的就设置为NO
@property (nonatomic, assign) BOOL isEndDecelerating;

@property (nonatomic, strong) UIView * tabSelectedLine;
@property (nonatomic, strong) NSMutableArray * tabButtons;
@property (nonatomic, strong) NSMutableArray * tabRedDots; //按钮上的红点
@property (nonatomic, strong) UIView * selectedLine;
@property (nonatomic, strong) UIView * shadowLine;
@property (nonatomic, assign) CGFloat selectedLineOffsetXBeforeMoving;

@end

@implementation PageTopView

- (void)buildUI
{
    _isBuildUI = NO;
    _isUseDragging = NO;
    _isEndDecelerating = YES;
    _startOffsetX = 0;
    _continueDraggingNumber = 0;
    
    NSInteger number = [self.delegate numberOfPagers:self];
    for (int i = 0; i < number; i++)
    {
        //ScrollView部分
        UIViewController* vc = [self.delegate pagerViewOfPagers:self indexOfPagers:i];
        [self.viewsArray addObject:vc];
        [self.bodyScrollView addSubview:vc.view];
        
        //tab上按钮
        UIButton * itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat itemButtonWidth = self.tabViewWidth / number;
        itemButton.backgroundColor = [UIColor clearColor];
        itemButton.frame = CGRectMake(itemButtonWidth * i, 0, itemButtonWidth, self.tabFrameHeight);
        [itemButton.titleLabel setFont:self.tabButtonFontSize];
        [itemButton setTitle:vc.navigationItem.title forState:UIControlStateNormal];
        [itemButton setTitleColor:self.tabButtonTitleColorForNormal forState:UIControlStateNormal];
        [itemButton setTitleColor:self.tabButtonTitleColorForSelected forState:UIControlStateSelected];
        [itemButton addTarget:self action:@selector(onTabButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = i;
        [self.tabButtons addObject:itemButton];
        [self.tabView addSubview:itemButton];
        
        //tab上的红点
        UIView * aRedDot = [[UIView alloc] initWithFrame:CGRectMake(itemButton.width / 2 + [self buttonTitleRealSize:itemButton].width / 2 + 3, itemButton.height / 2 - [self buttonTitleRealSize:itemButton].height / 2, 8, 8)];
        aRedDot.backgroundColor     = [UIColor redColor];
        aRedDot.layer.cornerRadius  = aRedDot.width/2.0f;
        aRedDot.layer.masksToBounds = YES;
        aRedDot.hidden = YES;
        [self.tabRedDots addObject:aRedDot];
        [itemButton addSubview:aRedDot];
    }
    //tabView
    self.tabView.backgroundColor = self.tabBackgroundColor;
    [self.tabView addSubview:self.shadowLine];
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
        self.bodyScrollView.contentSize = CGSizeMake(self.width * self.viewsArray.count, 0);
        for (int i = 0; i < [self.viewsArray count]; i++)
        {
            UIViewController* vc = self.viewsArray[i];
            vc.view.frame = CGRectMake(self.bodyScrollView.width * i, 0, self.bodyScrollView.width, self.bodyScrollView.height);
        }
    }
    [super layoutSubviews];
}

#pragma mark - Tab
- (void)onTabButtonSelected:(UIButton *)button
{
    [self selectTabWithIndex:button.tag animate:YES];
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
    
    [self switchWithIndex:index animate:isAnimate];
    
    if ( self.whenSelectOnPager )
    {
        self.whenSelectOnPager(index);
    }
    
    [self hideRedDotWithIndex:index];
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
- (UIView *)tabView
{
    if (!_tabView)
    {
        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabViewWidth, self.tabFrameHeight)];
        _tabView.backgroundColor = [UIColor clearColor];
    }
    return _tabView;
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
        [self.tabView addSubview:_selectedLine];
    }
    return _selectedLine;
}

- (UIView *)shadowLine
{
    if (!_shadowLine)
    {
        _shadowLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabView.height - 1, self.tabView.width, 1)];
        _shadowLine.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    }
    return _shadowLine;
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
