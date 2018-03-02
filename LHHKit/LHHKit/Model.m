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


#import "Model.h"
#import "API.h"
@implementation Model
+ (void)update
{
    V2_ECAPI_SPLASH_LIST_API * api = [[V2_ECAPI_SPLASH_LIST_API alloc] init];
    api.req.returnMsg = @"121";
    api.whenUpdated = ^( V2_ECAPI_SPLASH_LIST_RESPONSE * response,HTTPResponseError * responseError )
    {
        NSLog(@"%@",response);
        
    };
    
    [api send];
}
@end
