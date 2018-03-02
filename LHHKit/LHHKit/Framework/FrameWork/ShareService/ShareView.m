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


#import "ShareView.h"
#import "ServiceShare.h"
#import "SinaWeibo.h"
#import "WXChatShared.h"
#import "TencentOpenShared.h"
#import "UIView+TYAlertView.h"

@interface ShareItem : NSObject
@property (nonatomic, copy) NSString * img;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) SOCIAL_VENDOR socialVendor;
@end

@implementation ShareItem
@end

@interface ShareCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) ShareItem * item;
@end

@implementation ShareCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.imgView =  [self addImageViewWithString:@""];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(0);
        make.width.height.mas_equalTo(self.width - 40.f);
    }];
    
    self.titleLabel = [self addLabel:@"" Font:[UIFont systemFontOfSize:10] Color:[UIColor colorWithHexString:@"#343434"]];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@20);
        make.centerX.equalTo(self);
        make.top.equalTo(self.imgView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
}

- (void)setItem:(ShareItem *)item
{
    _item = item;
    
    self.imgView.image = [UIImage imageNamed:item.img];
    self.titleLabel.text = item.title;
}

@end

@interface ShareView ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionview;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end


@implementation ShareView

+ (void)makeShowShareViewOn:(UIViewController *)owner
                 sharedPost:(SharedPost *)model
                   complete:(void (^)(SHARE_STATUS type))complete;
{
    ShareView * shareView = [[ShareView alloc] initWithFrame:[ShareView returnShareViewRect]];
    shareView.model = model;
    shareView.whenSuccess = ^{
        if (complete)
        {    
            complete(SHARE_STATUS_SUCCESS);
        }
    };
    
    shareView.whenFail = ^{
        if (complete)
        {
            complete(SHARE_STATUS_FAIL);
        }
    };
    
    shareView.whenCancel = ^{
        if (complete)
        {
            complete(SHARE_STATUS_CANCEL);
        }
    };
    
    [shareView showInController:owner preferredStyle:TYAlertControllerStyleActionSheet backgoundTapDismissEnable:YES];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *label = [self addLabel:@"分享到" Font:[UIFont systemFontOfSize:15] Color:[UIColor colorWithHexString:@"#343434"]];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateDisabled];
    UIImage *normalImage = [[UIColor colorWithHexString:@"f24f51"] getImageWithSize:(CGSize){4,4}];
    normalImage = [normalImage stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    
    UIImage *disAbleImage = [[UIColor colorWithHexString:@"f24f51"] getImageWithSize:(CGSize){4,4}];
    disAbleImage = [disAbleImage stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [btn setBackgroundImage:disAbleImage forState:UIControlStateDisabled];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(hiddenShareView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(23));
        make.right.bottom.equalTo(@(-23));
        make.height.equalTo(@40);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 55 - 13.f, 75.f) collectionViewLayout:layout];
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    self.collectionview.scrollEnabled = NO;
    self.collectionview.backgroundColor = [UIColor whiteColor];
    //注册item
    [self.collectionview registerClass:[ShareCell class] forCellWithReuseIdentifier:@"ShareCell"];
    [self addSubview:self.collectionview];
    
    [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(label.mas_bottom);
        make.bottom.equalTo(btn.mas_top).offset(-20);
    }];
    
    [self setupShareData];
}

- (void)setupShareData
{
    self.dataArray = [NSMutableArray array];
    [self.dataArray removeAllObjects];
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        ShareItem * wxItem = [[ShareItem alloc] init];
        wxItem.img = @"weixin";
        wxItem.title = @"微信好友";
        wxItem.socialVendor = SOCIAL_VENDOR_Wechat;
        [self.dataArray addObject:wxItem];
        
        ShareItem * timeLineItem = [[ShareItem alloc] init];
        timeLineItem.img = @"pengyouquan";
        timeLineItem.title = @"朋友圈";
        timeLineItem.socialVendor = SOCIAL_VENDOR_TIMELINE;
        [self.dataArray addObject:timeLineItem];
    }
    
    if ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP])
    {
        ShareItem * wbItem = [[ShareItem alloc] init];
        wbItem.img = @"xinlang";
        wbItem.title = @"新浪微博";
        wbItem.socialVendor = SOCIAL_VENDOR_WEIBO;
        [self.dataArray addObject:wbItem];
    }

    if ([TencentOAuth iphoneQQInstalled] && [QQApiInterface isQQSupportApi])
    {
        ShareItem * qqItem = [[ShareItem alloc] init];
        qqItem.img = @"haoyou";
        qqItem.title = @"QQ好友";
        qqItem.socialVendor = SOCIAL_VENDOR_QQ;
        [self.dataArray addObject:qqItem];
        
        ShareItem * qqZoneItem = [[ShareItem alloc] init];
        qqZoneItem.img = @"qqZone";
        qqZoneItem.title = @"QQ空间";
        qqZoneItem.socialVendor = SOCIAL_VENDOR_QQZONE;
        [self.dataArray addObject:qqItem];
    }
    [self.collectionview reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArray.count)
    {
        return self.dataArray.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareCell" forIndexPath:indexPath];
    cell.item = [self.dataArray safeObjectAtIndex:indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateAlignedLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count)
    {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width / 4.f , [UIScreen mainScreen].bounds.size.width / 4.f + 30.f);
    }
    else
    {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width ,30.f);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count && self.model)
    {
        ShareItem * item = [self.dataArray safeObjectAtIndex:indexPath.item];
        
        switch (item.socialVendor)
        {
            case SOCIAL_VENDOR_Wechat:
            {
                [self wxchatSharedWithType:SOCIAL_VENDOR_Wechat];
            }
                break;
                
            case SOCIAL_VENDOR_TIMELINE:
            {
                [self wxchatSharedWithType:SOCIAL_VENDOR_TIMELINE];
            }
                break;
            case SOCIAL_VENDOR_QQ:
            {
                [self qqSharedWithType:SOCIAL_VENDOR_QQ];
            }
                break;
            case SOCIAL_VENDOR_QQZONE:
            {
                [self qqSharedWithType:SOCIAL_VENDOR_QQZONE];
            }
                break;
                
            case SOCIAL_VENDOR_WEIBO:
            {
                [self sinaShared];
            }
                break;
            default:
                break;
        }
    }
}

- (void)sinaShared
{
    ALIAS( [SinaWeibo sharedSinaWeibo], sina );
    sina.post = [self returnPost];
    
    @weakify(self);
    sina.whenShareSucceed = ^ {
        @strongify(self);
        // 分享成功
        if (self.whenSuccess)
        {
            self.whenSuccess();
        }
    };
    
    sina.whenShareFailed = ^ {
        // 分享失败
        if (self.whenFail)
        {
            self.whenFail();
        }
    };
    
    sina.whenShareCancelled = ^ {
        if (self.whenCancel)
        {
            self.whenCancel();
        }
    };
    
    [sina share];
}

- (void)wxchatSharedWithType:(SOCIAL_VENDOR)socialVendor
{
    ALIAS( [WXChatShared sharedWXChatShared], wxchat );
    wxchat.post = [self returnPost];
    @weakify(self);
    wxchat.whenShareSucceed = ^ {
        @strongify(self);
        // 分享成功
        if (self.whenSuccess)
        {
            self.whenSuccess();
        }
    };
    
    wxchat.whenShareFailed = ^ {
        // 分享失败
        if (self.whenFail)
        {
            self.whenFail();
        }
    };
    
    wxchat.whenShareCancelled = ^ {
        // 分享失败
        if (self.whenCancel)
        {
            self.whenCancel();
        }
    };
    
    if (socialVendor == SOCIAL_VENDOR_Wechat)
    {
        [wxchat shareFriend];
    }
    else
    {
        [wxchat shareTimeline];
    }
}

- (void)qqSharedWithType:(SOCIAL_VENDOR)socialVendor
{
    ALIAS( [TencentOpenShared sharedTencentOpenShared], tencent );
    
    tencent.post = [self returnPost];
    
    @weakify(self);
    tencent.whenShareSucceed = ^ {
        @strongify(self);
        // 分享成功
        if (self.whenSuccess)
        {
            self.whenSuccess();
        }
    };
    
    tencent.whenShareFailed = ^ {
        // 分享失败
        if (self.whenFail)
        {
            self.whenFail();
        }
    };
    
    tencent.whenShareCancelled = ^ {
        if (self.whenCancel)
        {
            self.whenCancel();
        }
    };
    
    if (socialVendor == SOCIAL_VENDOR_QQ)
    {
        [tencent shareQq];
    }
    else
    {
        [tencent shareQzone];
    }
}

- (SharedPost *)returnPost
{
    SharedPost * post = [[SharedPost alloc] init];
    post.title = self.model.title;
    post.text  = self.model.text;
    post.photo = self.model.photo;
    post.url  = self.model.url;
    
    return post;
}

- (void)hiddenShareView
{
    [self hideInController];
}

+ (CGRect)returnShareViewRect
{
    CGFloat shareViewHeight = 0;
    shareViewHeight += 20.f + 20.f + 23.f + 40.f + 20.f;
    
    NSInteger count = 0;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        count += 2;
    }
    
    if ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP])
    {
        count += 1;
    }
    
    if ([TencentOAuth iphoneQQInstalled] && [QQApiInterface isQQSupportApi])
    {
        count += 1;
    }
    
    shareViewHeight += ceil(count / 4.f) * ([UIScreen mainScreen].bounds.size.width / 4.f + 25.f);
    
    return CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

@end
