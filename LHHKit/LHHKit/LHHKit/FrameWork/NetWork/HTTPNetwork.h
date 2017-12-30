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
#import "HTTPSessionManager.h"

@class HTTPResponseError;

#pragma mark -

@interface HTTPBaseObject : NSObject
@property (nonatomic, assign, readonly) BOOL isValidated;
@end

#pragma mark -

@interface HTTPRequest : HTTPBaseObject

/**
 *  Transform properies to a dcitionary that can be parameter for a request.
 *
 *  @return a dictionary composed of properties
 */
@property (nonatomic, strong, readonly) NSDictionary * parameters;

/**
 *  Transform origin endpoint to parametered uri with known properies.
 *
 *  For example:
 *
 *  Endpoint: /users/:username/repos
 *  Result: /users/huanhuan/repos
 *
 *  @return the parametered uri
 */
@property (nonatomic, strong) NSString * endpoint;
@property (nonatomic, assign) HTTPRequestMethod method;
@property (nonatomic, assign) Class responseClass;

- (instancetype)initWithEndpoint:(NSString *)endpoint method:(HTTPRequestMethod)method;
+ (instancetype)requestWithEndpoint:(NSString *)endpoint method:(HTTPRequestMethod)method;

@end

#pragma mark -

@protocol HTTPResponse <NSObject>
@optional
@property (nonatomic, assign, readonly) BOOL isValidated;
@end

@interface HTTPResponse : HTTPBaseObject<HTTPResponse>
@end

@interface HTTPResponseError : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString * message;
@end

#pragma mark -

@class HTTPSessionManager;

@interface HTTPApi : HTTPBaseObject<HTTPResponseDataProcessor>

@property (nonatomic, weak) HTTPSessionManager * HTTPSessionManager;
@property (nonatomic, strong) HTTPRequest * req;
@property (nonatomic, strong) id<HTTPResponse> resp;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, weak) NSURLSessionDataTask * task;
@property (nonatomic, copy) HTTPApiBlock whenUpdated;
@property (nonatomic, copy) HTTPApiBlock whenFailed;
@property (nonatomic, copy) void (^ whenCanceled)(void);

/**
 * Api will not be auto cancelled, that means `[HTTPApi cacenl]` will not
 * cancel it if set YES.
 */
@property (nonatomic, assign) BOOL manuallyCancel;

- (void)send;
- (void)cancel;

/**
 * This operation will cancel all the apis kind of this class.
 */
+ (void)cancel;
+ (void)setGlobalHTTPSessionManager:(HTTPSessionManager *)HTTPSessionManager;

@end
