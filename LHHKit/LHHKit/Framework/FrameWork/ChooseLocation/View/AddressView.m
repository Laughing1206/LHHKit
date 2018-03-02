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

#import "AddressView.h"

static  CGFloat  const  HYBarItemMargin = 20;
@interface AddressView ()
@property (nonatomic,strong) NSMutableArray * btnArray;
@end

@implementation AddressView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (NSInteger i = 0; i <= self.btnArray.count - 1 ; i++)
    {
        UIView * view = self.btnArray[i];
        if (i == 0)
        {
            view.left = HYBarItemMargin;
        }
        if (i > 0)
        {
            UIView * preView = self.btnArray[i - 1];
            view.left = HYBarItemMargin + preView.right;
        }
    }
}

- (NSMutableArray *)btnArray
{
    NSMutableArray * mArray  = [NSMutableArray array];
    for (UIView * view in self.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [mArray addObject:view];
        }
    }
    _btnArray = mArray;
    return _btnArray;
}

@end
