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
#import "SharedPost.h"

typedef NS_ENUM(NSUInteger, SHARE_STATUS)
{
    SHARE_STATUS_UNKNOWN = 0, // 未知
    SHARE_STATUS_SUCCESS = 1, // 成功
    SHARE_STATUS_FAIL = 2, // 失败
    SHARE_STATUS_CANCEL = 3, // 取消
};


@interface ShareView : UIView

+ (void)makeShowShareViewOn:(UIViewController *)owner
                 sharedPost:(SharedPost *)model
               complete:(void (^)(SHARE_STATUS type))complete;

@property (nonatomic, strong) SharedPost * model;
@property (nonatomic, copy) void (^whenSuccess)(void);
@property (nonatomic, copy) void (^whenFail)(void);
@property (nonatomic, copy) void (^whenCancel)(void);

@end

