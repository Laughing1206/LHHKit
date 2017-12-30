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
@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) UIWebView * webView;
@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNav];
    [self setUI];
}

- (void)setNav
{
    self.navigationItem.title = self.titleString;
    if (self.navigationController.navigationBar.barTintColor == RGBA(255, 255, 255, 1.0))return;
    self.navigationController.navigationBar.barTintColor = RGBA(255, 255, 255, 1.0);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:RGB(31, 31, 31),NSFontAttributeName:[UIFont systemFontOfSize:17]};
}

- (void)setUI
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    // 检测所有数据类型
    [webView setDataDetectorTypes:UIDataDetectorTypeAll];
    
    //清除cookies
    NSHTTPCookie * cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    self.webView = webView;
    
    NSURL * url = [NSURL URLWithString:[self.urlString URLDecoding]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString * title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.navigationItem.title  = title;
}

@end
