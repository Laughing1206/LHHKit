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
#import "AFNetworking.h"

typedef void (^HTTPApiBlock)(id data, id error);

typedef NS_ENUM(NSUInteger, HTTPRequestMethod) {
    HTTPRequestMethodGet,
    HTTPRequestMethodHead,
    HTTPRequestMethodPost,
    HTTPRequestMethodPut,
    HTTPRequestMethodPatch,
    HTTPRequestMethodDelete,
};

FOUNDATION_EXPORT NSString * HTTPRequestMethodString(HTTPRequestMethod);

@class HTTPResponseError;

@protocol HTTPResponseDataProcessor <NSObject>

/**
 *  处理响应回来的数据
 *
 *   responseObject 请求响应返回的数据，已经过 ResponseSerializer 处理
 *   task           请求的任务，在这里可以拿到响应的Header信息等
 *
 *  @return 返回处理过的 responseObject
 */
- (id)processedDataWithResponseObject:(id)responseObject task:(NSURLSessionDataTask *)task allHeaders:(NSDictionary *)allHeaders;

/**
 *  处理请求错误
 *
 *   error 错误信息
 */
- (void)handleError:(NSError *)error responseObject:(id)responseObject task:(NSURLSessionDataTask *)task failureBlock:(HTTPApiBlock)failureBlock;

@end

@interface HTTPSessionManager : AFHTTPSessionManager<HTTPResponseDataProcessor>

/**
 *  每次请求都会回调这个 block，用于配置公共参数，Header信息等
 */
@property (nonatomic, copy) void (^setup)(id vars, ...);

/**
 *  处理请求数据
 *
 *   method     请求方式，一般默认super
 *   endpoint   endpoint，一般默认super
 *   parameters 请求参数，可以重写这个函数统一处理
 *   success    成功回调，一般默认super
 *   failure    失败毁掉，一般默认super
 *
 *  @return 默认返回super
 */
- (NSURLSessionDataTask *)method:(HTTPRequestMethod)method
                        endpoint:(NSString *)endpoint
                      parameters:(id)parameters
                      completion:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))completion;

@end

