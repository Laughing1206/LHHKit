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


#import "MJRefreshComponent.h"

typedef enum {
    MJRefreshFooterStateIdle = 1, // 普通闲置状态
    MJRefreshFooterStateRefreshing, // 正在刷新中的状态
    MJRefreshFooterStateNoMoreData // 所有数据加载完毕，没有更多的数据了
} MJRefreshFooterState;

@interface MJRefreshFooter : MJRefreshComponent
/** 提示没有更多的数据 */
- (void)noticeNoMoreData;
/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)resetNoMoreData;

/** 刷新控件的状态(交给子类重写) */
@property (assign, nonatomic) MJRefreshFooterState state;

/** 是否隐藏状态标签 */
@property (assign, nonatomic, getter=isStateHidden) BOOL stateHidden;

/**
 * 设置state状态下的状态文字内容title
 */
- (void)setTitle:(NSString *)title forState:(MJRefreshFooterState)state;

/** 是否自动刷新(默认为YES) */
@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh;
@end
