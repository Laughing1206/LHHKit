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


#import "MJRefreshGifFooter.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"

@interface MJRefreshGifFooter()
/** 播放动画图片的控件 */
@property (weak, nonatomic) UIImageView *gifView;
@end

@implementation MJRefreshGifFooter
#pragma mark - 懒加载
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

#pragma mark - 初始化方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 指示器
    self.gifView.frame = self.bounds;
    if (self.stateHidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifView.contentMode = UIViewContentModeRight;
        self.gifView.mj_w = self.mj_w * 0.5 - 90;
    }
}

#pragma mark - 公共方法
- (void)setState:(MJRefreshFooterState)state
{
    if (self.state == state) return;
    
    switch (state) {
        case MJRefreshFooterStateIdle:
            self.gifView.hidden = YES;
            [self.gifView stopAnimating];
            break;
            
        case MJRefreshFooterStateRefreshing:
            self.gifView.hidden = NO;
            [self.gifView startAnimating];
            break;
            
        case MJRefreshFooterStateNoMoreData:
            self.gifView.hidden = YES;
            [self.gifView stopAnimating];
            break;
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

- (void)setRefreshingImages:(NSArray *)refreshingImages
{
    _refreshingImages = refreshingImages;
    
    self.gifView.animationImages = refreshingImages;
    self.gifView.animationDuration = refreshingImages.count * 0.1;
    
    // 根据图片设置控件的高度
    UIImage *image = [refreshingImages firstObject];
    if (image.size.height > self.mj_h) {
        _scrollView.mj_insetB -= self.mj_h;
        self.mj_h = image.size.height;
        _scrollView.mj_insetB += self.mj_h;
    }
}

@end
