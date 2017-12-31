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



#import "TWVersionChecker.h"

//此链接为苹果官方查询App的接口。
#define kAPPURL     @"http://itunes.apple.com/lookup?id="

@interface TWVersionChecker ()

@end

@implementation TWVersionChecker

+ (void)checkVersionForAppId:(NSString *)appId completionHandler:(void (^)(BOOL hasNew, NSString *updateText, NSString *updateUrl, NSString *version))completionHandler
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kAPPURL, appId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

             if (error) {
                 if (completionHandler) {
                     completionHandler(NO, nil, nil, nil);
                 }
             } else {
                 NSDictionary *remoteInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                 NSString *latestVersion = [remoteInfo[@"results"] firstObject][@"version"];
                 NSString *releaseNotes = [remoteInfo[@"results"] firstObject][@"releaseNotes"];
                 NSString *updateUrl = [remoteInfo[@"results"] firstObject][@"trackViewUrl"];
                
                 if ((completionHandler)) {
                     completionHandler(YES, releaseNotes, updateUrl, latestVersion);
                 }
                
             }
         });
     }];
#pragma clang diagnostic pop
}

@end
