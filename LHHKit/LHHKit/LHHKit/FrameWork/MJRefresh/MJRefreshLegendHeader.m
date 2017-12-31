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


#import "MJRefreshLegendHeader.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"

@interface MJRefreshLegendHeader()
@property (nonatomic, weak) UIImageView *arrowImage;
@property (nonatomic, assign) BOOL isbeginAnimtion;
@end

@implementation MJRefreshLegendHeader

#pragma mark - 懒加载
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {

        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mj_resources.bundle/mj_down"]];
        
        [self insertSubview:_arrowImage = arrowImage aboveSubview:self.bgImage];
    }

    return _arrowImage;
}
#pragma mark - 初始化
- (void)layoutSubviews
{
    [super layoutSubviews];

	// 设置自己的位置
	self.mj_y = - self.mj_h - self.insetTop ;

    // 箭头
    CGFloat arrowX = (self.stateHidden && self.updatedTimeHidden) ? self.mj_w * 0.5 : (self.mj_w * 0.5 - 40);
    self.arrowImage.center = CGPointMake(arrowX, self.mj_h * 0.5);
}

#pragma mark - 公共方法
#pragma mark 设置状态
- (void)setState:(MJRefreshHeaderState)state
{
    if (self.state == state) return;

    // 旧状态
    MJRefreshHeaderState oldState = self.state;

    switch (state) {
        case MJRefreshHeaderStateIdle: {
            if (oldState == MJRefreshHeaderStateRefreshing)
            {
                [self stopAnimation];
                [UIView animateWithDuration:0 animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                }];
                self.arrowImage.image = [UIImage imageNamed:@"mj_resources.bundle/mj_success"];
                [self setTitle:@"加载成功" forState:state];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ( self.isbeginAnimtion )
                    {
                        return;
                    }
                    self.arrowImage.image = [UIImage imageNamed:@"mj_resources.bundle/mj_down"];
                    
                    [self setTitle:@"下拉刷新" forState:state];
                });
                
            }
            else
            {
                self.arrowImage.image = [UIImage imageNamed:@"mj_resources.bundle/mj_down"];
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
            break;
        }
            
        case MJRefreshHeaderStatePulling:
        {
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowImage.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
            break;
        }
            
        case MJRefreshHeaderStateRefreshing:
        {
            self.isbeginAnimtion = YES;
            self.arrowImage.image = [UIImage imageNamed:@"mj_resources.bundle/mj_loading"];
            [self.arrowImage.layer addAnimation:[self rotationAuto] forKey:@"rotationAnimation"];
            break;
        }
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

- (CABasicAnimation *)rotationAuto
{
	CABasicAnimation* rotationAnimation;
	rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
	rotationAnimation.duration = 1;
	rotationAnimation.repeatCount = 1000;
	return rotationAnimation;
}

- (void)stopAnimation
{
	[self.arrowImage.layer removeAnimationForKey:@"rotationAnimation"];
    self.isbeginAnimtion = NO;
}

@end
