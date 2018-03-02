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
#import "AppService.h"

#pragma mark -

typedef	void	(^ServiceBlock)( void );
typedef	void	(^ServiceBlockN)( id first );

#pragma mark -

@interface ServicePay : NSObject <AppService>

SingletonInterface(ServicePay)

@property (nonatomic, readonly) ServiceBlock PAY;

@property (nonatomic, copy) ServiceBlock whenWaiting;
@property (nonatomic, copy) ServiceBlock whenSucceed;
@property (nonatomic, copy) ServiceBlock whenFailed;
@property (nonatomic, copy) ServiceBlock whenCancel;

- (void)powerOn;

@end
