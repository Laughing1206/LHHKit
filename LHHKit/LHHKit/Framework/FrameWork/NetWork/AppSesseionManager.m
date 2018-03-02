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

#import "AppSesseionManager.h"
#import "AFURLRequestSerialization.h"
#import "TradeEncryption.h"

@implementation AppSesseionManager

+ (void)load
{
    [HTTPApi setGlobalHTTPSessionManager:[self sharedManager]];
}

- (id)processedDataWithResponseObject:(id)responseObject task:(NSURLSessionDataTask *)task allHeaders:(NSDictionary *)allHeaders
{
    if ( [responseObject isKindOfClass:NSDictionary.class] )
    {
        NSString * returnMsg = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"returnMsg"]];
        
//#错误代码
//        const ERRCODE_AUTHTOKEN_VOID = 10000; //登录失效
//        const ERRCODE_MEMBER_VOID = 10001; //用户不存在
//        const ERRCODE_MEMBER_LOCK = 10002; //用户锁定
//        const ERRCODE_SIGNTRUE_VOID = 10003; //签名失效
        
        if ([returnMsg isNoEmpty])
        {
//            if ( [returnMsg isEqualToString:@"10000"] ||
//                [returnMsg isEqualToString:@"10001"] ||
//                [returnMsg isEqualToString:@"10002"] ||
//                [returnMsg isEqualToString:@"10003"])
//            {
//                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                [appDelegate.currentRootViewController.currentViewController presentFailureTips:@"账户异常，请重新登录"];
//
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [[UserModel sharedUserModel] kickout];//退出登录
//                });
//
//            }
        }
    }
    
    return responseObject;
}

- (NSURLSessionDataTask *)method:(HTTPRequestMethod)method endpoint:(NSString *)endpoint parameters:(id)parameters completion:(void (^)(NSURLSessionDataTask *, id, NSError *))completion
{
    // 在这加密
    NSURLSessionDataTask * task = [super method:method
                                       endpoint:endpoint
                                     parameters:parameters
                                     completion:completion];
    return task;
}

- (NSURLSessionDataTask *)method:(HTTPRequestMethod)method
                        endpoint:(NSString *)endpoint
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))failure
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    // 这个函数里断点看请求的数据
    NSURLSessionDataTask * task = [super method:method endpoint:endpoint
                                     parameters:(parameters ? params : nil)
                                     completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                                         
                                     }];
    
    return task;
}

+ (instancetype)sharedManager
{
    static AppSesseionManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AppSesseionManager alloc] initWithBaseURL:[NSURL URLWithString:[AppConfig sharedAppConfig].kAppServerAPIURL]];
        
        sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain" ,@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/png",@"image/jpeg",@"application/rtf",@"image/gif",@"application/zip",@"audio/x-wav",@"image/tiff",@"     application/x-shockwave-flash",@"application/vnd.ms-powerpoint",@"video/mpeg",@"video/quicktime",@"application/x-javascript",@"application/x-gzip",@"application/x-gtar",@"application/msword",@"text/css",@"video/x-msvideo",@"text/xml", nil];
        
        // 设置超时时间
        sharedManager.requestSerializer.timeoutInterval = 20;
        sharedManager.setup = ^(id vars,...) {
            [sharedManager setupParams];
        };
    });
    
    return sharedManager;
}

- (void)setupParams
{
    
}

+ (NSString *)generateSignWithParams:(NSDictionary *)params
{
    NSArray * keys = [params allKeys];
    
    NSArray * sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                             {
                                 return [obj1 compare:obj2 options:NSNumericSearch];
                             }];
    
    NSMutableString * param = [NSMutableString string];
    
    for (NSString * key in sortedArray)
    {
        if ( [key isEqualToString:@"attachFile"] )
        {
            continue;
        }
        
        [param appendString:[NSString stringWithFormat:@"%@=%@&", key, [params objectForKey:key]]];
    }
    
    if ( sortedArray.count )
    {
        param = (NSMutableString *)[param substringWithRange:NSMakeRange(0, param.length-1)];
    }
    
    return param;
}

@end

@implementation NSObject (APIExtension)

+ (id)processedValueForKey:(NSString *)key
               originValue:(id)originValue
            convertedValue:(id)convertedValue
                     class:(__unsafe_unretained Class)clazz
                  subClass:(__unsafe_unretained Class)subClazz
{
    if ( [clazz isEqual:NSNumber.class] )
    {
        if (  [originValue isKindOfClass:NSString.class] )
        {
            return @([originValue doubleValue]);
        }
    }
    
    if ( [clazz isEqual:NSString.class] )
    {
        if (  [originValue isKindOfClass:NSNumber.class] )
        {
            return [originValue description];
        }
    }
    
    return convertedValue;
}

@end

