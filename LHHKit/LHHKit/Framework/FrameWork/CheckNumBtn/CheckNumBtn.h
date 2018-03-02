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

typedef BOOL(^CheckRevokeBlock)(void);
typedef void(^CheckVoidBlock)(void);

@interface CheckNumBtn : UIButton

//默认是获取验证码
@property (nonatomic, copy) NSString * normalTitle;
@property (nonatomic, strong) UIColor * normalColor;
//@required区分不同页面用的；
@property (nonatomic, copy) NSString * counterID;
@property (nonatomic, copy) NSString * phoneNum;

@property (nonatomic, copy) void (^whenTap)(id data);

- (instancetype)initWithCountID:(NSString *)aID withString:(NSString *)str;

///点击事件，可自行发送请求获取验证码,返回YES就开始计时！！
- (void)tapAction:(CheckRevokeBlock)aBlcok;

///在点击之后自动发送请求；并且开始计时；
- (void)autoSendRequestwithPhone:(NSString *)aPhone startBlock:(CheckVoidBlock)startBlock completeHandle:(void(^)(bool isTrue,NSError* error))comBlock;

- (void)startCount:(NSTimeInterval)af;

//重置倒计时⌛️（s）
- (void)reSetCount:(NSTimeInterval)af;
/**
 *  如果距离上次开始计时设置的时间还没到，那么可以从剩下的时间开始计时；
 *  return: YES,继续计时；NO，不需要继续计时
 */
- (BOOL)continueCountIfNeed;

///暂停计时；
- (void)pasueCount;

///停止计时；将销毁计时器，在页面销毁前调用；
- (void)stopCount;

@end
