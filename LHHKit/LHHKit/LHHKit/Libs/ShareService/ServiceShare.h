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
#import <UIKit/UIKit.h>
#import "SharedPost.h"
#import "AppService.h"

typedef	void	(^ServiceBlock)( void );
typedef	void	(^ServiceBlockN)( id first );

@interface ServiceShare : NSObject <AppService>

SingletonInterface(ServiceShare)

@property (nonatomic, strong) SharedPost * post;

@property (nonatomic, copy) NSString * appKey;
@property (nonatomic, copy) NSString * appId;
@property (nonatomic, copy) NSString * redirectUrl;

@property (nonatomic, copy) ServiceBlock					whenShareBegin;
@property (nonatomic, copy) ServiceBlock					whenShareSucceed;
@property (nonatomic, copy) ServiceBlock					whenShareFailed;
@property (nonatomic, copy) ServiceBlock					whenShareCancelled;

@property (nonatomic, copy) ServiceBlock					whenFollowBegin;
@property (nonatomic, copy) ServiceBlock					whenFollowSucceed;
@property (nonatomic, copy) ServiceBlock					whenFollowFailed;
@property (nonatomic, copy) ServiceBlock					whenFollowCancelled;

@property (nonatomic, copy) ServiceBlock					whenGetUserInfoBegin;
@property (nonatomic, copy) ServiceBlockN					whenGetUserInfoSucceed;
@property (nonatomic, copy) ServiceBlock					whenGetUserInfoFailed;
@property (nonatomic, copy) ServiceBlock					whenGetUserInfoCancelled;

- (void)powerOn;

@end
