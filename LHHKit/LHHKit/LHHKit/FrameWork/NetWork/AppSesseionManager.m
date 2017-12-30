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
    //    if ( allHeaders )
    //    {
    //        NSInteger errCode = [[allHeaders objectAtPath:@"X-ECAPI-ErrorCode"] integerValue];
    //        if ( ( errCode ==  ERROR_CODE_UNKNOWN_ERROR ||
    //             errCode == ERROR_CODE_TOKEN_INVALID  ||
    //             errCode == ERROR_CODE_TOKEN_EXPIRED  ||
    //             errCode == ERROR_CODE_SIGN_INVALID   ||
    //             errCode == ERROR_CODE_SIGN_EXPIRED ) )
    //        {
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                [[UserModel sharedInstance] kickout];
    //            });
    //        }
    //    }
    
    //    return responseObject;
    
    if ( [responseObject isKindOfClass:NSDictionary.class] )
    {
        NSNumber * success = [responseObject valueForKey:@"success"];
        
        if ( !success.boolValue ) {
            
            //NSLog( @"%@", [responseObject valueForKey:@"message"] );
            
//            NSNumber * error_code = [responseObject valueForKey:@"error_code"];
//
//            if ( error_code.intValue == ERROR_CODE_SESSION_EXPIRED ||
//                error_code.intValue == ERROR_CODE_UNKNOWN_ERROR ||
//                error_code.intValue == 3002)
//            {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [[UserModel sharedInstance] kickout];//退出登录
//                });
//
//            }
        }
    }
    
    return responseObject;
    
}

//- (void)handleError:(NSError *)error responseObject:(id)responseObject task:(NSURLSessionDataTask *)task failureBlock:(void (^)(id data, id allHeaders, id error))failureBlock
//{
//    HTTPResponseError * error = [HTTPResponseError new];
//    e.code = error.code;
//    e.message = @"数据获取失败，请检查您的网络";
//
//    if ( failureBlock )
//    {
//        failureBlock(nil, nil, e);
//    }
//}

- (NSURLSessionDataTask *)method:(HTTPRequestMethod)method endpoint:(NSString *)endpoint parameters:(id)parameters completion:(void (^)(NSURLSessionDataTask *, id, NSError *))completion
{
    //在此处加密
    
    [AppSesseionManager sharedManager].responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain" ,@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/png",@"image/jpeg",@"application/rtf",@"image/gif",@"application/zip",@"audio/x-wav",@"image/tiff",@"     application/x-shockwave-flash",@"application/vnd.ms-powerpoint",@"video/mpeg",@"video/quicktime",@"application/x-javascript",@"application/x-gzip",@"application/x-gtar",@"application/msword",@"text/css",@"video/x-msvideo",@"text/xml", nil];
    
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
        
        //        sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
        //        [sharedManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

