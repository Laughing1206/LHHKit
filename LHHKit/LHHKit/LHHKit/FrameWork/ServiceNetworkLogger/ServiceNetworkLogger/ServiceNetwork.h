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

#import "AppService.h"

typedef NS_ENUM(NSUInteger, ServiceNetworkLogLevel) {
	ServiceNetworkLogOff,
	ServiceNetworkLogDebug,
	ServiceNetworkLogInfo,
	ServiceNetworkLogWarn,
	ServiceNetworkLogError,
	ServiceNetworkLogFatal = ServiceNetworkLogOff,
};

@interface ServiceNetworkLog : NSObject
@property (nonatomic, copy) NSURLRequest * request;
@property (nonatomic, copy) NSURLResponse * response;
@property (nonatomic, copy) NSDictionary * responseObject;
@property (nonatomic, copy) NSDictionary * userInfo;
@property (nonatomic, assign) CGFloat elapsedTime;
@property (nonatomic, strong) NSDate * startAt;
@property (nonatomic, strong) NSDate * endedAt;
@property (nonatomic, strong) NSError * error;
@property (nonatomic, strong) NSString * sendByte;
@property (nonatomic, strong) NSString * receiveByte;
@property (nonatomic, strong) NSString * totalByte;
@end

FOUNDATION_EXPORT NSString * const ServiceNetworkLogDidChangeNotification;

@interface ServiceNetwork : NSObject <AppService>

@property (nonatomic, assign) ServiceNetworkLogLevel logLevel;
@property (nonatomic, strong, readonly) NSArray * logs;

SingletonInterface(ServiceNetwork)

- (void)addRequest:(NSURLRequest *)request;
- (void)addLog:(ServiceNetworkLog *)log;

- (void)show;
- (void)hide;

@end
