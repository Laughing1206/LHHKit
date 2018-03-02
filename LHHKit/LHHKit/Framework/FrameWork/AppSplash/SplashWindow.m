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


#import "SplashWindow.h"

#define durationCount 5
@interface SplashWindow ()
{
    NSTimer * _timer;
    NSUInteger _count;
}

@property (nonatomic, strong) UIImageView * splash;
@property (nonatomic, assign) BOOL hiding;
@property (nonatomic, assign) BOOL shouldAutoHide;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UILabel * countdownLabel;

@property (nonatomic, strong) NSTimer * timer;

@end

#pragma mark -

@implementation SplashWindow

SingletonImplemention(SplashWindow)

#pragma mark -

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor whiteColor];
        self.windowLevel = UIWindowLevelStatusBar;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    
    self.splash = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, screenFrame.size.width, screenFrame.size.height)];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMask)];
    [self.splash addGestureRecognizer:tapGesture];
    self.splash.userInteractionEnabled = YES;
    self.splash.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.splash];
    
    // 自动隐藏splashWindow，默认值为YES
    self.shouldAutoHide = YES;
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.rootViewController = appDelegate.window.rootViewController;
    
    [self addMaskView];
}

- (void)startTimer
{
    if ( nil == self.timer )
    {
        _count = 0;
        
        [self.timer invalidate];
        self.timer = nil;
        
        if ( [NSThread isMainThread] )
        {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                          target:self
                                                        selector:@selector(countDown)
                                                        userInfo:nil
                                                         repeats:YES];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^ {
                // 回到主线程
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                              target:self
                                                            selector:@selector(countDown)
                                                            userInfo:nil
                                                             repeats:YES];
            });
        }
    }
}

#pragma mark -

- (void)addMaskView
{
    if ( self.bottomView == nil )
    {
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake( screenFrame.size.width - 100.f, 15.f, 90.f, 25.f )];
        
        self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        self.bottomView.layer.cornerRadius = 2.f;
        [self addSubview:self.bottomView];
        
        
        NSString * durationStr = [NSString stringWithFormat:@"%lds", (long)durationCount];
        
        self.countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 40.f, self.bottomView.frame.size.height )];
        self.countdownLabel.attributedText = [self countdownAttributedString:durationStr];
        self.countdownLabel.textAlignment = NSTextAlignmentCenter;
        [self.bottomView addSubview:self.countdownLabel];
        
        [self updateUI];
        
        UILabel * tips = [[UILabel alloc] initWithFrame:CGRectMake( self.countdownLabel.frame.size.width, 0, 50.f, self.bottomView.frame.size.height )];
        tips.text = @"跳过";
        tips.font = [UIFont systemFontOfSize:14.f];
        tips.textAlignment = NSTextAlignmentCenter;
        tips.textColor = [UIColor whiteColor];
        [self.bottomView addSubview:tips];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake( self.countdownLabel.frame.size.width , 6, 1, 13.f )];
        line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
        [self.bottomView addSubview:line];
        
        UIButton * mask = [UIButton buttonWithType:UIButtonTypeCustom];
        mask.frame = self.bottomView.frame;
        [mask addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mask];
    }
}

#pragma mark -

- (void)updateUI
{
    NSInteger count = durationCount - _count;
    
    if ( 1 >= count )
    {
        count = 1;
    }
    
    self.countdownLabel.attributedText = [self countdownAttributedString:[NSString stringWithFormat:@"%lds", (long)count]];
}

#pragma mark -

- (void)countDown
{
    _count += 1;
    
    [self updateUI];
    
    if ( _count >= durationCount )
    {
        [self.timer invalidate];
        self.timer = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [self checkAutoHide];
        });
    }
}

- (void)show
{
    if ( !self.hidden )
    {
        return;
    }
    
    if (!self.model)
    {
        [self hide];
        return;
    }
    
    if (!self.model.image)
    {
        [self hide];
        return;
    }

    self.shouldAutoHide = YES;
    
    [self updateUI];
    [self startTimer];
    
    self.hidden = NO;
    
    [self loadSplashImage];
}

- (void)hide
{
    [self hideAnimated:YES completion:nil];
}

- (void)hideWithCompletion:(void(^)(void))completion
{
    [self hideAnimated:YES completion:completion];
}

- (void)hideAnimated:(BOOL)animated completion:(void(^)(void))completion
{
    if ( self.hidden ) {
        return;
    }
    
    if ( self.hiding ) {
        return;
    }
    
    self.hiding = YES;
    
    if ( animated )
    {
        [self didHidden];
        [UIView animateWithDuration:0.35f
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                         }
                         completion:^(BOOL finished){
                             [self didHidden];
                             if ( completion ) {
                                 completion();
                             }
                         }];
        
    }
    else
    {
        [self didHidden];
    }
}

- (void)didHidden
{
    self.hiding = NO;
    self.hidden = YES;
    
    [self.timer invalidate];
    self.timer = nil;
    _count = 0;
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.rootViewController = appDelegate.window.rootViewController;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
#pragma clang diagnostic pop
}

#pragma mark -

- (void)checkAutoHide
{
    if ( self.shouldAutoHide )
    {
        [self hide];
    }
}

#pragma mark -

- (void)loadSplashImage
{
    self.splash.image = self.model.image;
}

#pragma mark -

- (void)tapMask
{
    if ( self.model.url && self.model.url.length )
    {
        [self hideAnimated:YES completion:^ {
            
            
//            WebViewController * webViewController = [[WebViewController alloc] init];
//            webViewController.urlString = self.model.url;
//            webViewController.titleString = @"活动";
//            AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            MMDrawerController * mmDrawerController = (MMDrawerController *)appDelegate.window.rootViewController;
//            if (mmDrawerController.centerViewController.childViewControllers)
//            {
//                DCNavigationController * navigationController = (DCNavigationController *) [mmDrawerController.centerViewController.childViewControllers safeObjectAtIndex:0];
//                [navigationController pushViewController:webViewController animated:YES];
//            }
        }];
    }
}

// splash广告页倒计时的样式字符串
- (NSMutableAttributedString *)countdownAttributedString:(NSString *)str
{
    // 单位为秒，所以字符串分割位置在总字符长度-1的位置(每公里用时)
    return [self attributedString:str
                     withLocation:str.length - 1
                        leadColor:[UIColor whiteColor]
                         leadFont:[UIFont systemFontOfSize:16]
                       trailColor:[UIColor whiteColor]
                        trailFont:[UIFont systemFontOfSize:16]];
}

- (NSMutableAttributedString *)attributedString:(NSString *)str
                                   withLocation:(NSUInteger)location
                                      leadColor:(UIColor *)leadColor
                                       leadFont:(UIFont *)leadFont
                                     trailColor:(UIColor *)trailColor
                                      trailFont:(UIFont *)trailFont
{
    if ( str == nil )
        return nil;
    
    NSMutableAttributedString * placeholder = nil;
    if ( str.length == location )
    {
        placeholder = [[NSMutableAttributedString alloc] initWithString:str];
        NSDictionary * attributes = @{NSForegroundColorAttributeName : leadColor, NSFontAttributeName : leadFont};
        [placeholder addAttributes:attributes range:NSMakeRange(0, location)];
    }
    else
    {
        placeholder = [[NSMutableAttributedString alloc] initWithString:str];
        NSDictionary * leadAttributes = @{NSForegroundColorAttributeName : leadColor, NSFontAttributeName : leadFont};
        [placeholder addAttributes:leadAttributes range:NSMakeRange(0, location)];
        NSDictionary * trialAttributes = @{NSForegroundColorAttributeName : trailColor, NSFontAttributeName : trailFont};
        [placeholder addAttributes:trialAttributes range:NSMakeRange(location , str.length - location)];
    }
    
    return placeholder;
}


@end
