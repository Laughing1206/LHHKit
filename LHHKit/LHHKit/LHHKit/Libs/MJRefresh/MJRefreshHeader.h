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

// 下拉刷新控件的状态
typedef enum {
    /** 普通闲置状态 */
    MJRefreshHeaderStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    MJRefreshHeaderStatePulling,
    /** 正在刷新中的状态 */
    MJRefreshHeaderStateRefreshing,
    /** 即将刷新的状态 */
    MJRefreshHeaderStateWillRefresh
} MJRefreshHeaderState;

@interface MJRefreshHeader : MJRefreshComponent

@property (nonatomic, assign) BOOL isShowBgImageView;

/** 利用这个key来保存上次的刷新时间（不同界面的刷新控件应该用不同的dateKey，以区分不同界面的刷新时间） */
@property (copy, nonatomic) NSString *dateKey;

/** 利用这个block来决定显示的更新时间 */
@property (copy, nonatomic) NSString *(^updatedTimeTitle)(NSDate *updatedTime);
/**
 * 设置state状态下的状态文字内容title(别直接拿stateLabel修改文字)
 */
- (void)setTitle:(NSString *)title forState:(MJRefreshHeaderState)state;
/** 刷新控件的状态 */
@property (assign, nonatomic) MJRefreshHeaderState state;

#pragma mark - 文字控件的可见性处理
/** 是否隐藏状态标签 */
@property (assign, nonatomic, getter=isStateHidden) BOOL stateHidden;
/** 是否隐藏刷新时间标签 */
@property (assign, nonatomic, getter=isUpdatedTimeHidden) BOOL updatedTimeHidden;

#pragma mark - 交给子类重写
/** 下拉的百分比(交给子类重写) */
@property (assign, nonatomic) CGFloat pullingPercent;

// 背景
@property (nonatomic, weak) UIImageView *bgImage;

@end
