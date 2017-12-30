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


#import "ShareEngine.h"
#import "SinaWeibo.h"
#import "WXChatShared.h"
#import "TencentOpenShared.h"

@implementation ShareEngine

SingletonImplemention(ShareEngine)

+ (void)setupService;
{
    ALIAS( [SinaWeibo sharedSinaWeibo], sina );
    ALIAS( [WXChatShared sharedWXChatShared], wxchat );
    ALIAS( [TencentOpenShared sharedTencentOpenShared], tencent );
    
    sina.appKey = @"689189342";
    sina.redirectUrl = @"https://api.weibo.com/oauth2/default.html";
    [sina powerOn];
    
    wxchat.appId = @"wxcef9e3d07a8a61c7";
    wxchat.appKey = @"de002fa5fce62f17f34ac20a241a1347";
    [wxchat powerOn];
    
    tencent.appId = @"1105715975";
    tencent.appKey = @"KEYp5ZI5TywQTEVGXMg";
    [tencent powerOn];
}
@end
