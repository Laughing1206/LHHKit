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

#import "HTTPSessionManager.h"
#import "AFHTTPSessionManager+URLSwitch.h"

NSString * HTTPRequestMethodString(HTTPRequestMethod method)
{
    NSString * methodString = nil;
    switch ( method ) {
        case HTTPRequestMethodGet:
            methodString = @"GET";
            break;
        case HTTPRequestMethodHead:
            methodString = @"HEAD";
            break;
        case HTTPRequestMethodPost:
            methodString = @"POST";
            break;
        case HTTPRequestMethodPut:
            methodString = @"PUT";
            break;
        case HTTPRequestMethodPatch:
            methodString = @"PATCH";
            break;
        case HTTPRequestMethodDelete:
            methodString = @"DELETE";
            break;
    }
    return methodString;
}

@implementation HTTPSessionManager

- (id)processedDataWithResponseObject:(id)responseObject task:(NSURLSessionDataTask *)task allHeaders:(NSDictionary *)allHeaders
{
    return responseObject;
}

- (void)handleError:(NSError *)error responseObject:(id)responseObject task:(NSURLSessionDataTask *)task failureBlock:(HTTPApiBlock)failureBlock
{
    if ( failureBlock ) {
        //        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        //        NSDictionary *allHeaders = response.allHeaderFields;
        failureBlock(nil, error);
    }
}

- (NSURLSessionDataTask *)method:(HTTPRequestMethod)method
                        endpoint:(NSString *)endpoint
                      parameters:(id)parameters
                      completion:(void (^)(NSURLSessionDataTask *, id, NSError *))completion
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:HTTPRequestMethodString(method)
                                                        URLString:endpoint
                                                       parameters:parameters
                                                       completion:completion];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                      completion:(void (^)(NSURLSessionDataTask *, id, NSError *))completion
{
    NSError *serializationError = nil;
    
    NSURL * baseUrl = self.baseURL;
    
    if ( self.currentBaseURL && self.currentBaseURL.length )
    {
        baseUrl = [NSURL URLWithString:self.currentBaseURL];
    }
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:baseUrl] absoluteString] parameters:parameters error:&serializationError];
    
    if (serializationError) {
        if (completion) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                completion(nil, nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;

    dataTask = [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        completion(dataTask, responseObject, error);
    }];
    return dataTask;
}

@end

