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


#import "API.h"


@implementation V2_ECAPI_SPLASH_LIST_REQUEST
@end

@implementation V2_ECAPI_SPLASH_LIST_RESPONSE
@end

@implementation V2_ECAPI_SPLASH_LIST_API

@synthesize req = _req;
@synthesize resp = _resp;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.req = [V2_ECAPI_SPLASH_LIST_REQUEST requestWithEndpoint:@"Api/Userv9/merchant_type" method:HTTPRequestMethodPost];
        self.req.responseClass = [V2_ECAPI_SPLASH_LIST_RESPONSE class];
    }
    return self;
}

@end
