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

#import "ServiceNetwork.h"
#import "ServiceNetworkWindow.h"
#import "AFNetworkActivityLogger.h"
#import "PinView.h"

@implementation ServiceNetworkLog
@end

@interface ServiceNetwork ()
@property (nonatomic, strong) NSMutableArray * requests;
@property (nonatomic, strong) NSMutableArray * tasks;
@property (nonatomic, strong) ServiceNetworkWindow * playground;
@property (nonatomic, weak) UIWindow * lastKeyWindow;
@end

#pragma mark -

NSString * const ServiceNetworkLogDidChangeNotification = @"ServiceNetworkLogDidChangeNotification";

@implementation ServiceNetwork

SingletonImplemention(ServiceNetwork)

+ (void)load
{
    [AppService addService:[self sharedServiceNetwork]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
        [self setupDock];
    });
    
    return YES;
}

+ (void)start
{
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
        [[self sharedServiceNetwork] setupDock];
    });
}

- (void)setupDock
{
    CGRect frame = [UIScreen mainScreen].bounds;
    
    PinView * pin = [[PinView alloc] initWithFrame:CGRectMake(frame.size.width - 60, frame.size.height - 210, 50, 50)];
    
    [[UIApplication sharedApplication].delegate.window addSubview:pin];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = pin.bounds;
    [pin addSubview:button];
    
    button.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.9].CGColor;
    button.layer.borderWidth = 2;
    button.layer.cornerRadius = 25;
    
    [button addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    
    button.titleLabel.font = [UIFont systemFontOfSize:28];
    [button setTitle:@"🚀" forState:UIControlStateNormal];
    button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
}

#pragma mark -

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requests = [NSMutableArray array];
        self.tasks = [NSMutableArray array];
    }
    return self;
}

- (void)setLogLevel:(ServiceNetworkLogLevel)logLevel
{
    [AFNetworkActivityLogger sharedLogger].level = (AFHTTPRequestLoggerLevel)logLevel;
}

- (void)addRequest:(NSURLRequest *)request
{
    [self.requests addObject:request];
}

- (void)addLog:(ServiceNetworkLog *)log
{
    [self.tasks insertObject:log atIndex:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ServiceNetworkLogDidChangeNotification object:nil];
}

- (NSArray *)logs
{
    return self.tasks;
}

- (void)show
{
    self.lastKeyWindow = [UIApplication sharedApplication].delegate.window;
    self.playground = [ServiceNetworkWindow new];
    [self.playground showThen:nil];
}

- (void)hide
{
    __weak typeof (self) weakSelf = self;
    [self.playground hideThen:^(BOOL finished) {
        [weakSelf.lastKeyWindow makeKeyWindow];
        weakSelf.playground = nil;
    }];
}

#pragma mark - ManagedDocker

- (void)install
{
}

- (void)uninstall
{
}

- (void)powerOn
{
}

- (void)powerOff
{
}

- (void)didDockerOpen
{
}

- (void)didDockerClose
{
    
}

@end
