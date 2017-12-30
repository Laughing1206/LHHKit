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



#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SOCIAL_VENDOR)
{
    SOCIAL_VENDOR_UNKNOWN = 0, // 未知
    SOCIAL_VENDOR_Wechat = 1, // 微信
    SOCIAL_VENDOR_TIMELINE = 2, // 朋友圈
    SOCIAL_VENDOR_WEIBO = 3, // 微博
    SOCIAL_VENDOR_QQ = 4, // QQ
    SOCIAL_VENDOR_QQZONE = 5, // QQ空间
};

@interface ACCOUNT : NSObject
@property (nonatomic, assign) SOCIAL_VENDOR socialVendor;
@property (nonatomic, strong) NSString * access_token;
@property (nonatomic, strong) NSString * open_id;
@end

@interface SharedPost : NSObject
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) id		 photo;
@property (nonatomic, strong) NSString * url;

- (void)copyFrom:(SharedPost *)post;
- (void)clear;

@end
