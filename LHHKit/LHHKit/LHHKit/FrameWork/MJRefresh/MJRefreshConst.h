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

// 日志输出
#ifdef DEBUG
#define MJLog(...) NSLog(__VA_ARGS__)
#else
#define MJLog(...)
#endif

// 过期提醒
#define MJDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define msgSendT(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define msgTarget(target) (__bridge void *)(target)

// RGB颜色
#define MJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define MJRefreshLabelTextColor MJColor(100, 100, 100)

// 字体大小
#define MJRefreshLabelFont [UIFont boldSystemFontOfSize:12]

// 图片路径
#define MJRefreshSrcName(file) [@"MJRefresh.bundle" stringByAppendingPathComponent:file]

// 常量
UIKIT_EXTERN const CGFloat MJRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat MJRefreshFooterHeight;
UIKIT_EXTERN const CGFloat MJRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat MJRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const MJRefreshHeaderUpdatedTimeKey;
UIKIT_EXTERN NSString *const MJRefreshContentOffset;
UIKIT_EXTERN NSString *const MJRefreshContentSize;
UIKIT_EXTERN NSString *const MJRefreshPanState;

UIKIT_EXTERN NSString *const MJRefreshHeaderStateIdleText;
UIKIT_EXTERN NSString *const MJRefreshHeaderStatePullingText;
UIKIT_EXTERN NSString *const MJRefreshHeaderStateRefreshingText;

UIKIT_EXTERN NSString *const MJRefreshFooterStateIdleText;
UIKIT_EXTERN NSString *const MJRefreshFooterStateRefreshingText;
UIKIT_EXTERN NSString *const MJRefreshFooterStateNoMoreDataText;
