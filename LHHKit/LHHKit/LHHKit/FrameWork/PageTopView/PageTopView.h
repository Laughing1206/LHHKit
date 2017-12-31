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

#import <UIKit/UIKit.h>

@protocol PageTopViewDelegate;
@interface PageTopView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView   * bodyScrollView;
@property (nonatomic, weak) id<PageTopViewDelegate> delegate;
@property (nonatomic, copy) void (^whenSelectOnPager)(NSInteger index);//切换到不同pager可执行的事件
@property (nonatomic, assign) CGFloat tabFrameHeight;//头部tab高
@property (nonatomic, assign) CGFloat selectedLineWidth;//下划线的宽
@property (nonatomic, assign) CGFloat tabMargin;//头部tab左右两端和边缘的间隔
@property (nonatomic, assign) CGFloat tabViewWidth;//头部tab宽度
@property (nonatomic, strong) UIFont  * tabButtonFontSize;//头部tab按钮字体大小
@property (nonatomic, strong) UIColor * tabButtonTitleColorForNormal;
@property (nonatomic, strong) UIColor * tabBackgroundColor;//头部tab背景颜色
@property (nonatomic, strong) UIColor * tabButtonTitleColorForSelected;
@property (nonatomic, strong) UIView  * tabView;

/**
 *  自定义完毕后开始build UI
 */
- (void)buildUI;

/**
 *  控制选中tab的button
 */
- (void)selectTabWithIndex:(NSInteger)index animate:(BOOL)isAnimate;
- (void)showRedDotWithIndex:(NSInteger)index;
- (void)hideRedDotWithIndex:(NSInteger)index;

@end

@protocol PageTopViewDelegate <NSObject>
@required
- (NSInteger)numberOfPagers:(PageTopView *)view;
- (UIViewController *)pagerViewOfPagers:(PageTopView *)view indexOfPagers:(NSInteger)number;

@end
