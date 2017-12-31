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



#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, copy) NSString * currentURL;@end

@implementation WebViewController

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    self.progressView = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNav];
    [self setUI];
}

- (void)setNav
{
    self.navigationItem.title = self.titleString;
}

- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentURL = [self.urlString URLDecoding];
    
    WKWebViewConfiguration * configuration = [WKWebViewConfiguration new];
    configuration.allowsInlineMediaPlayback = YES;
    configuration.selectionGranularity = WKSelectionGranularityDynamic;
    configuration.dataDetectorTypes = UIDataDetectorTypeNone;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kscreen_width, kscreen_height - TabbarBottomOffset) configuration:configuration];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.opaque = NO;
    
    [self.view addSubview:self.webView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        
        if (result && [result isKindOfClass:[NSString class]])
        {
            NSString * wkWebViewUserAgent = result;
            if (![wkWebViewUserAgent containsString:@"LHHKit"])
            {
                NSString * wkWebViewNewUserAgent = [wkWebViewUserAgent stringByAppendingString:@" LHHKit"];//自定义需要拼接的字符串
                NSDictionary * wkWebViewDictionary = [NSDictionary dictionaryWithObjectsAndKeys:wkWebViewNewUserAgent, @"UserAgent", nil];
                [[NSUserDefaults standardUserDefaults] registerDefaults:wkWebViewDictionary];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }];
    
    [self clearWebCache];
    NSURL * url = [NSURL URLWithString:[self.urlString URLDecoding]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)startFullScreen
{
    UIApplication * application = [UIApplication sharedApplication];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [application setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    CGRect frame = [UIScreen mainScreen].applicationFrame;
#pragma clang diagnostic pop
    
    BOOL isVideo = NO;
    for (UIViewController * subViewController in application.keyWindow.rootViewController.childViewControllers)
    {
        if ([subViewController isKindOfClass:[NSClassFromString(@"AVPlayerViewController") class]] ||
            [subViewController isKindOfClass:[NSClassFromString(@"AVFullScreenViewController") class]] ||
            [subViewController isKindOfClass:[NSClassFromString(@"AVFullScreenPlaybackControlsViewController") class]] ||
            [subViewController isKindOfClass:[NSClassFromString(@"MPMoviePlayerController") class]] ||
            [subViewController isKindOfClass:[NSClassFromString(@"WebFullScreenVideoRootViewController") class]])
        {
            isVideo = YES;
        }
        for (UIViewController * childViewController in subViewController.childViewControllers)
        {
            if ([childViewController isKindOfClass:[NSClassFromString(@"AVPlayerViewController") class]] ||
                [childViewController isKindOfClass:[NSClassFromString(@"AVFullScreenViewController") class]] ||
                [childViewController isKindOfClass:[NSClassFromString(@"AVFullScreenPlaybackControlsViewController") class]] ||
                [childViewController isKindOfClass:[NSClassFromString(@"MPMoviePlayerController") class]] ||
                [childViewController isKindOfClass:[NSClassFromString(@"WebFullScreenVideoRootViewController") class]])
            {
                isVideo = YES;
            }
        }
    }
    
    
    for (UIView * subView in application.keyWindow.rootViewController.view.subviews)
    {
        if ([subView isKindOfClass:[NSClassFromString(@"AVPlayerView") class]])
        {
            isVideo = YES;
        }
    }
    
    
    if (isVideo)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            application.keyWindow.bounds = CGRectMake(0, 0, frame.size.height + 20 + TabbarBottomOffset, frame.size.width);
            application.keyWindow.transform = CGAffineTransformMakeRotation(M_PI/2);
        });
    }
}

- (void)endFullScreen
{
    UIApplication * application = [UIApplication sharedApplication];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [application setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
    CGRect frame = [UIScreen mainScreen].applicationFrame;
#pragma clang diagnostic pop
    application.keyWindow.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height + 20);
    application.keyWindow.transform = CGAffineTransformMakeRotation(M_PI * 2);
}

- (void)clearWebCache
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
    {
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                                                   modifiedSince:[NSDate dateWithTimeIntervalSince1970:0]
                                               completionHandler:^{
                                                   
                                               }];
    }
    else
    {
        NSString * libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES)objectAtIndex:0];
        NSError * errors;
        [[NSFileManager defaultManager]removeItemAtPath:[libraryPath stringByAppendingString:@"/Cookies"] error:&errors];
    }
}

#pragma mark 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"https://itunes.apple.com"])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
#pragma clang diagnostic pop
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    if ([navigationAction.request.URL.absoluteString isEqualToString:@"renrenbaiyi://video-beginfullscreen"])
    {
        [self startFullScreen];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    else if ([navigationAction.request.URL.absoluteString isEqualToString:@"renrenbaiyi://video-endfullscreen"])
    {
        [self endFullScreen];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    self.currentURL = webView.URL.absoluteString;
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    if (![webView.URL.absoluteString isEqualToString:@"http://a1.7x24cc.com/phone_webChat.html?accountId=N000000010129&chatId=hhr-9bfa5ec0-1452-11e7-8209-39bc2bfb2a9c"])
    {
        self.navigationItem.title = webView.title;
    }
    
    NSString * videoHandlerString = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Videofullscreenhandler.js"] encoding:NSUTF8StringEncoding error:nil];
    if (videoHandlerString)
    {
        [webView evaluateJavaScript:videoHandlerString completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"value: %@ error: %@", response, error);
        }];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)backClick
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"])
    {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1)
        {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }
        else
        {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (UIProgressView *)progressView
{
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height - 2.f, kscreen_width, 2.f)];
        _progressView.tintColor = [UIColor orangeColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

@end
