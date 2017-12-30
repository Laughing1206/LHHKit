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


#import "AFHTTPSessionManager+URLSwitch.h"
#import <objc/runtime.h>
static const void * kCurrentBaseURL;

@implementation AFHTTPSessionManager (URLSwitch)

- (NSString *)currentBaseURL
{
    return objc_getAssociatedObject(self, &kCurrentBaseURL);
}

- (void)setCurrentBaseURL:(NSString *)currentBaseURL
{
    objc_setAssociatedObject(self, &kCurrentBaseURL, currentBaseURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
