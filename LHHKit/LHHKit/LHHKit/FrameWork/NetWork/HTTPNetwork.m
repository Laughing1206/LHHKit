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


#import "HTTPNetwork.h"
#import "AutoCoding.h"
#import "NSObject+AutoCoding.h"
#import "AFNetworking.h"
#import "TradeEncryption.h"

#pragma mark -

@implementation HTTPBaseObject

- (BOOL)isValidated
{
    return YES;
}

- (NSString *)description
{
    return [[self dictionaryRepresentation] description];
}

@end

#pragma mark -

@interface HTTPApiManager : NSObject

SingletonInterface(HTTPApiManager)

@property (nonatomic, strong) NSMutableDictionary * apis;

- (void)cancel:(HTTPApi *)api;

@end

@implementation HTTPApiManager

SingletonImplemention(HTTPApiManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.apis = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)add:(id)api
{
    NSString * clazz = NSStringFromClass([api class]);
    NSMutableArray * apis = self.apis[clazz];
    if ( !apis )
    {
        self.apis[clazz] = [NSMutableArray arrayWithObject:api];
    }
    else
    {
        [apis addObject:api];
    }
}

- (void)cancel:(id)api
{
    [self removeAll:[api class]];
}

- (void)remove:(id)api
{
    NSString * clazz = NSStringFromClass([api class]);
    NSMutableArray * apis = self.apis[clazz];
    if ( apis && apis.count )
    {
        [apis removeObject:api];
    }
}

- (void)removeAll:(Class)clazz
{
    NSMutableArray * apis = self.apis[NSStringFromClass(clazz)];
    if ( apis && apis.count )
    {
        [apis enumerateObjectsUsingBlock:^(HTTPApi * obj, NSUInteger idx, BOOL *stop) {
            if ( !obj.manuallyCancel )
            {
                [obj cancel];
            }
        }];
        [apis removeAllObjects];
    }
}

- (void)send:(id)api
{
    [self cancel:api];
    [self add:api];
}

@end

#pragma mark -

static HTTPSessionManager * kGlobalHTTPSessionManager = nil;

@implementation HTTPApi

+ (void)setGlobalHTTPSessionManager:(HTTPSessionManager *)HTTPSessionManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kGlobalHTTPSessionManager = HTTPSessionManager;
    });
}

+ (void)cancel
{
    [[HTTPApiManager sharedHTTPApiManager] removeAll:self];
}

- (void)dealloc
{
    [self cancel];
}

- (HTTPSessionManager *)HTTPSessionManager
{
    if ( _HTTPSessionManager == nil ) {
        return kGlobalHTTPSessionManager;
    }
    // TODO: nil check
    return _HTTPSessionManager;
}

- (id)processedDataWithResponseObject:(id)responseObject task:(NSURLSessionDataTask *)task allHeaders:(NSDictionary *)allHeaders
{
    // By default, just make the HTTPSessionManager process data
    return responseObject;
}

- (void)handleError:(NSError *)error responseObject:(id)responseObject task:(NSURLSessionDataTask *)task failureBlock:(HTTPApiBlock)failureBlock
{
    // By default, just make the HTTPSessionManager handle error
    [self.HTTPSessionManager handleError:error responseObject:responseObject task:task failureBlock:failureBlock];
}

- (void)send
{
    if ( self.HTTPSessionManager.setup ) {
        self.HTTPSessionManager.setup(nil);
    }
    
    [[HTTPApiManager sharedHTTPApiManager] send:self];
    
    self.task = [self.HTTPSessionManager method:self.req.method
                                       endpoint:self.req.endpoint
                                     parameters:self.req.parameters
                                     completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                                         
                                         // 请求成功，将自己从manager中移除
                                         [[HTTPApiManager sharedHTTPApiManager] remove:self];
                                         if (error)
                                         {
                                             // 请求被取消
                                             if ( NSURLErrorCancelled == error.code )
                                             {
                                                 if ( self.whenCanceled )
                                                 {
                                                     self.whenCanceled();
                                                 }
                                             }
                                             else
                                             {
                                                 [self.HTTPSessionManager handleError:error
                                                                       responseObject:responseObject
                                                                                 task:task
                                                                         failureBlock:self.whenUpdated];
                                             }
                                         }
                                         else
                                         {
                                             // 请求成功，解析数据
                                             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                                             NSDictionary *allHeaders = response.allHeaderFields;
                                             
                                             id responseJson = nil;
                                             
                                             if ( [responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSMutableDictionary class]] )
                                             {
                                                 NSString * json = [TradeEncryption decryptBase64StringToString:[responseObject objectAtPath:@"data"]?:@"" stringKey:TRACE_ENCRYPTION_KEY sign:YES];
                                                 
                                                 responseJson = [json dictionaryWithJsonString];
                                             }
                                             else
                                             {
                                                 responseJson = responseObject;
                                             }
                                             
                                             id resp = [self.HTTPSessionManager processedDataWithResponseObject:responseObject task:task allHeaders:nil];
                                             
                                             self.resp = [self.req.responseClass ac_objectWithAny:resp];
                                             self.responseObject = responseJson;
                                             
                                             HTTPResponseError * responseError = [HTTPResponseError new];
                                             responseError.code = [[allHeaders objectAtPath:@"X-ECAPI-ErrorCode"] integerValue];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                             responseError.message = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                                                           (__bridge CFStringRef)[allHeaders objectAtPath:@"X-ECAPI-ErrorDesc"],
                                                                                                                                                           CFSTR(""),
                                                                                                                                                           CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
#pragma clang diagnostic pop
                                             if ( self.whenUpdated )
                                             {
                                                 self.whenUpdated(self.resp, nil);
                                             }
                                         }
                                     }];
}

- (void)cancel
{
    if ( self.task )
    {
        switch ( self.task.state )
        {
            case NSURLSessionTaskStateRunning:
            case NSURLSessionTaskStateSuspended:
                [self.task cancel];
                break;
            case NSURLSessionTaskStateCanceling:
            case NSURLSessionTaskStateCompleted:
                break;
        }
    }
}

@end

#pragma mark -

@interface HTTPRequest()
@end

#pragma mark -

@implementation HTTPRequest

@synthesize method = _method;
@synthesize endpoint = _endpoint;

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        NSAssert(NO, @"You should use [HTTPRequest initWithEndpoint:] instead.");
//    }
//    return self;
//}

- (instancetype)initWithEndpoint:(NSString *)endpoint method:(HTTPRequestMethod)method
{
    self = [super init];
    if (self) {
        _endpoint = endpoint;
        _method = method;
    }
    return self;
}

+ (instancetype)requestWithEndpoint:(NSString *)endpoint method:(HTTPRequestMethod)method
{
    return [[self alloc] initWithEndpoint:endpoint method:method];
}

- (NSDictionary *)parameters
{
    NSDictionary * parameters = [self dictionaryRepresentation];
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dic removeObjectForKey:@"endpoint"];
    [dic removeObjectForKey:@"method"];
    
    return dic;
}

- (NSString *)endpoint
{
    NSAssert(_endpoint && _endpoint.length, @"Are you kiding ?! The URI endpoint for requset should not be empty");
    
    if ( [_endpoint hasPrefix:@"/"] )
    {
        _endpoint = [_endpoint substringFromIndex:1];
    }
    
    NSArray * partials = [_endpoint componentsSeparatedByString:@"/"];
    
    NSArray * targets = [partials filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[c] ':'"]];
    
    __block NSMutableString * path = [_endpoint mutableCopy];
    
    [targets enumerateObjectsUsingBlock:^(NSString * str, __unused NSUInteger idx, __unused BOOL *stop) {
        
        NSString * keyPath = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
        keyPath = [keyPath stringByDeletingPathExtension];
        
        NSString * param = [self valueForKeyPath:keyPath];
        
        [path replaceOccurrencesOfString:str
                              withString:[param description]
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange(0, path.length)];
    }];
    
    return path;
}

@end

#pragma mark -

@implementation HTTPResponse

- (BOOL)isValidated
{
    return YES;
}

@end

#pragma mark -

@implementation HTTPResponseError
@end
