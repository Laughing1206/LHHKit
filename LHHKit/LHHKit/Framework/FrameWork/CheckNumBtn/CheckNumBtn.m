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



#import "CheckNumBtn.h"

@interface CheckNumBtn ()

@property (nonatomic,strong) UILabel * subTitleLabel;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) CheckRevokeBlock tapRevokeBlock;
@property (nonatomic,copy) CheckVoidBlock startBlock;
@property (nonatomic,copy) void (^requestRecokeBlock)(bool, NSError *error);

@end

@implementation CheckNumBtn

- (instancetype)initWithCountID:(NSString *)aID withString:(NSString *)str
{
    self = [super init];
    if (self) {
        
        NSParameterAssert(aID);
        self.counterID = aID;
        self.normalTitle = str;
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.subTitleLabel.font = [UIFont systemFontOfSize:12];
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.subTitleLabel];
        [self makeTitleLabelNormalText];
        self.timer = [[NSTimer alloc]initWithFireDate:[NSDate distantFuture] interval:1 target:self selector:@selector(timerConuting) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self addTarget:self action:@selector(tapMySelf) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.subTitleLabel];
    [self makeTitleLabelNormalText];
    self.timer = [[NSTimer alloc]initWithFireDate:[NSDate distantFuture] interval:1 target:self selector:@selector(timerConuting) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self addTarget:self action:@selector(tapMySelf) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击事件

- (void)tapMySelf
{
    if (self.tapRevokeBlock)
    {
        if (self.tapRevokeBlock())
        {
            [self startCount:60];
        }
    }
    else if(self.startBlock)
    {
        self.startBlock();
        [self startCount:60];
    }
    else if (self.whenTap)
    {
        self.whenTap(nil);
    }
}

///开始倒计时；
- (void)timerConuting
{
    NSString *str = [self remindTimeIntevalFor:_counterID];
    if (str) {
        self.subTitleLabel.text = str;
    }else{
        [self.timer pauseTimer];
        [self makeTitleLabelNormalText];
    }
}

- (BOOL)continueCountIfNeed
{
    NSParameterAssert(_counterID);
    if ([self remindTimeIntevalFor:_counterID]) {
        [self prepareTimerCounting];
        [self.timer resumeTimer];
    }else{
        [self.timer pauseTimer];
        [self makeTitleLabelNormalText];
    }
    return NO;
}

- (void)tapAction:(CheckRevokeBlock)aBlcok
{
    self.tapRevokeBlock = aBlcok;
}

- (void)autoSendRequestwithPhone:(NSString *)aPhone startBlock:(CheckVoidBlock)startBlock completeHandle:(void (^)(bool, NSError *))comBlock
{
    self.phoneNum = aPhone;
    self.startBlock = startBlock;
    self.requestRecokeBlock = comBlock;
}

- (NSString *)remindTimeIntevalFor:(NSString *)aID
{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:aID];
    if (date) {
        NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate date]];
        int second = (int)interval;
        if (second > 0) {
            return [NSString stringWithFormat:@"(%zis)后重发",second];
        }
    }
    return nil;
}

- (void)makeTitleLabelNormalText
{
    self.subTitleLabel.text = self.normalTitle;
    self.subTitleLabel.textColor = self.normalColor;
    self.enabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15.f;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = self.normalColor.CGColor;
    
}

- (void)prepareTimerCounting
{
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.enabled = NO;
    self.backgroundColor = [UIColor lightGrayColor];
    self.layer.borderWidth = 0;
    self.layer.borderColor = self.normalColor.CGColor;
    
}

- (void)reSetCount:(NSTimeInterval)af
{
    NSParameterAssert(_counterID);
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate dateWithTimeIntervalSinceNow:af] forKey:_counterID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)startCount:(NSTimeInterval)af
{
    NSParameterAssert(_counterID);
    if (af > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate dateWithTimeIntervalSinceNow:af] forKey:_counterID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self prepareTimerCounting];
        [self.timer resumeTimer];
    }
}

- (void)pasueCount
{
    [self.timer pauseTimer];
}

- (void)stopCount
{
    [self.timer invalidate];
    self.timer = nil;
}

@end

