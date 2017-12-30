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


@property (nonatomic,strong) UILabel *titleLabel;
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
        self.layer.cornerRadius = 3;
        self.counterID = aID;
        self.normalTitle = str;
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [self makeTitleLabelNormalText];
        self.timer = [[NSTimer alloc]initWithFireDate:[NSDate distantFuture] interval:1 target:self selector:@selector(timerConuting) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self addTarget:self action:@selector(tapMySelf) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

#pragma mark - 点击事件

- (void)tapMySelf
{
    if (self.tapRevokeBlock) {
        if (self.tapRevokeBlock()) {
            [self startCount:61];
        }
    }else if(self.startBlock){
        self.startBlock();
        [self startCount:61];
    }
}

///开始倒计时；
- (void)timerConuting
{
    NSString *str = [self remindTimeIntevalFor:_counterID];
    if (str) {
        _titleLabel.text = str;
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
    _titleLabel.text = self.normalTitle;
    _titleLabel.textColor = RGB(233,97,19);
    self.enabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 17;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = RGB(233,97,19).CGColor;
    
}

- (void)prepareTimerCounting
{
    _titleLabel.textColor = [UIColor whiteColor];
    self.enabled = NO;
    self.backgroundColor = [UIColor lightGrayColor];
    self.layer.borderWidth = 0;
    self.layer.borderColor = RGB(233,97,19).CGColor;
    
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

