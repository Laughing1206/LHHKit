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
@property (nonatomic, copy) NSString * currentURL;
@end

@implementation WebViewController

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNav];
    [self setUI];
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

- (void)setNav
{
    self.navigationItem.title = self.titleString;
    
    @weakify(self);
    self.navigationItem.leftBarButtonItems = @[[AppTheme itemWithContent:[UIImage imageNamed:@"back"] handler:^(id sender) {
        @strongify(self);
        
        if (self.isNativeBack)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
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
    }]];
}

- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentURL = [self.urlString URLDecoding];
    
    WKWebViewConfiguration * configuration = [WKWebViewConfiguration new];
    configuration.allowsInlineMediaPlayback = YES;
    configuration.selectionGranularity = WKSelectionGranularityDynamic;
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
            if (![wkWebViewUserAgent containsString:@"SunnyProject"])
            {
                NSString * wkWebViewNewUserAgent = [wkWebViewUserAgent stringByAppendingString:@" SunnyProject"];//自定义需要拼接的字符串
                NSDictionary * wkWebViewDictionary = [NSDictionary dictionaryWithObjectsAndKeys:wkWebViewNewUserAgent, @"UserAgent", nil];
                [[NSUserDefaults standardUserDefaults] registerDefaults:wkWebViewDictionary];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }];
    
    [[AppTheme sharedAppTheme] clearWebCache];
    NSURL * url = [NSURL URLWithString:[self.urlString URLDecoding]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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
    self.navigationItem.title = webView.title;
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
