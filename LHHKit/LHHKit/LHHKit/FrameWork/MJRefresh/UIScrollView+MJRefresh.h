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
#import "MJRefreshConst.h"

@class MJRefreshGifHeader, MJRefreshLegendHeader, MJRefreshHeader;
@class MJRefreshGifFooter, MJRefreshLegendFooter, MJRefreshFooter;

@interface UIScrollView (MJRefresh)
#pragma mark - 访问下拉刷新控件
/** 下拉刷新控件 */
@property (strong, nonatomic, readonly) MJRefreshHeader *header;
/** gif功能的下拉刷新控件 */
@property (nonatomic, readonly) MJRefreshGifHeader *gifHeader;
/** 传统的下拉刷新控件 */
@property (nonatomic, readonly) MJRefreshLegendHeader *legendHeader;

#pragma mark - 添加下拉刷新控件

/**
 * 添加一个传统的下拉刷新控件  显示背景图片
 *
 *  block 进入刷新状态就会自动调用这个block
 */
- (MJRefreshLegendHeader *)addShowBgImageLegendHeaderWithRefreshingBlock:(void (^)(void))block;

/**
 * 添加一个传统的下拉刷新控件
 *
 *  block 进入刷新状态就会自动调用这个block
 */
- (MJRefreshLegendHeader *)addLegendHeaderWithRefreshingBlock:(void (^)(void))block;
/**
 * 添加一个传统的下拉刷新控件
 *
 *  block     进入刷新状态就会自动调用这个block
 *  dateKey   用来记录刷新时间的key
 */
- (MJRefreshLegendHeader *)addLegendHeaderWithRefreshingBlock:(void (^)(void))block dateKey:(NSString *)dateKey;
/**
 * 添加一个传统的下拉刷新控件
 *
 *  target 进入刷新状态就会自动调用target对象的action方法
 *  action 进入刷新状态就会自动调用target对象的action方法
 */
- (MJRefreshLegendHeader *)addLegendHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
/**
 * 添加一个传统的下拉刷新控件
 *
 *  target    进入刷新状态就会自动调用target对象的action方法
 *  action    进入刷新状态就会自动调用target对象的action方法
 *  dateKey   用来记录刷新时间的key
 */
- (MJRefreshLegendHeader *)addLegendHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action dateKey:(NSString *)dateKey;
/**
 * 添加一个gif图片的下拉刷新控件
 *
 *  block 进入刷新状态就会自动调用这个block
 */
- (MJRefreshGifHeader *)addGifHeaderWithRefreshingBlock:(void (^)(void))block;
/**
 * 添加一个gif图片的下拉刷新控件
 *
 *  block     进入刷新状态就会自动调用这个block
 *  dateKey   用来记录刷新时间的key
 */
- (MJRefreshGifHeader *)addGifHeaderWithRefreshingBlock:(void (^)(void))block dateKey:(NSString *)dateKey;
/**
 * 添加一个gif图片的下拉刷新控件
 *
 *  target 进入刷新状态就会自动调用target对象的action方法
 *  action 进入刷新状态就会自动调用target对象的action方法
 */
- (MJRefreshGifHeader *)addGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
/**
 * 添加一个gif图片的下拉刷新控件
 *
 *  target    进入刷新状态就会自动调用target对象的action方法
 *  action    进入刷新状态就会自动调用target对象的action方法
 *  dateKey   用来记录刷新时间的key
 */
- (MJRefreshGifHeader *)addGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action dateKey:(NSString *)dateKey;

#pragma mark - 移除下拉刷新控件
/**
 * 移除下拉刷新控件
 */
- (void)removeHeader;

#pragma mark - 访问上拉刷新控件
/** 上拉刷新控件 */
@property (strong, nonatomic, readonly) MJRefreshFooter *footer;
/** gif功能的上拉刷新控件 */
@property (nonatomic, readonly) MJRefreshGifFooter *gifFooter;
/** 传统的上拉刷新控件 */
@property (nonatomic, readonly) MJRefreshLegendFooter *legendFooter;

#pragma mark - 添加上拉刷新控件
/**
 * 添加一个传统的上拉刷新控件
 *
 *  block 进入刷新状态就会自动调用这个block
 */
- (MJRefreshLegendFooter *)addLegendFooterWithRefreshingBlock:(void (^)(void))block;
/**
 * 添加一个传统的上拉刷新控件
 *
 *  target 进入刷新状态就会自动调用target对象的action方法
 *  action 进入刷新状态就会自动调用target对象的action方法
 */
- (MJRefreshLegendFooter *)addLegendFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
/**
 * 添加一个gif图片的上拉刷新控件
 *
 *  block 进入刷新状态就会自动调用这个block
 */
- (MJRefreshGifFooter *)addGifFooterWithRefreshingBlock:(void (^)(void))block;
/**
 * 添加一个gif图片的上拉刷新控件
 *
 *  target 进入刷新状态就会自动调用target对象的action方法
 *  action 进入刷新状态就会自动调用target对象的action方法
 */
- (MJRefreshGifFooter *)addGifFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

#pragma mark - 移除上拉刷新控件
/**
 * 移除上拉刷新控件
 */
- (void)removeFooter;
@end

#pragma mark - 1.0.0版本以前的接口
@interface UIScrollView(MJRefreshDeprecated)
#pragma mark - 下拉刷新
/**
 *  添加一个下拉刷新头部控件
 *
 *   callback 回调
 */
- (void)addHeaderWithCallback:(void (^)(void))callback MJDeprecated("建议使用addLegendHeaderWithRefreshingBlock:");

/**
 *  添加一个下拉刷新头部控件
 *
 *   callback 回调
 *   dateKey 刷新时间保存的key值
 */
- (void)addHeaderWithCallback:(void (^)(void))callback dateKey:(NSString *)dateKey MJDeprecated("建议使用addLegendHeaderWithRefreshingBlock:dateKey:");

/**
 *  添加一个下拉刷新头部控件
 *
 *   target 目标
 *   action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action MJDeprecated("建议使用addLegendHeaderWithRefreshingTarget:refreshingAction:");

/**
 *  添加一个下拉刷新头部控件
 *
 *   target 目标
 *   action 回调方法
 *   dateKey 刷新时间保存的key值
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action dateKey:(NSString *)dateKey MJDeprecated("建议使用addLegendHeaderWithRefreshingTarget:refreshingAction:dateKey:");

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing MJDeprecated("建议使用[self.tableView.header beginRefreshing]");

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing MJDeprecated("建议使用[self.tableView.header endRefreshing]");

/**
 *  下拉刷新头部控件的可见性
 */
@property (nonatomic, assign, getter = isHeaderHidden) BOOL headerHidden MJDeprecated("建议使用self.tableView.header.hidden");

/**
 *  是否正在下拉刷新
 */
@property (nonatomic, assign, readonly, getter = isHeaderRefreshing) BOOL headerRefreshing MJDeprecated("建议使用self.tableView.header.isRefreshing");

#pragma mark - 上拉刷新
/**
 *  添加一个上拉刷新尾部控件
 *
 *   callback 回调
 */
- (void)addFooterWithCallback:(void (^)(void))callback MJDeprecated("建议使用addLegendFooterWithRefreshingBlock:");

/**
 *  添加一个上拉刷新尾部控件
 *
 *   target 目标
 *   action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action MJDeprecated("建议使用addLegendFooterWithRefreshingTarget:refreshingAction:");

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing MJDeprecated("建议使用[self.tableView.footer beginRefreshing]");

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing MJDeprecated("建议使用[self.tableView.footer endRefreshing]");

/**
 *  上拉刷新头部控件的可见性
 */
@property (nonatomic, assign, getter = isFooterHidden) BOOL footerHidden MJDeprecated("建议使用self.tableView.footer.hidden");

/**
 *  是否正在上拉刷新
 */
@property (nonatomic, assign, readonly, getter = isFooterRefreshing) BOOL footerRefreshing MJDeprecated("建议使用self.tableView.footer.isRefreshing");
@end
