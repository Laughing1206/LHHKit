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

#import "UIButton+Signal.h"

@implementation UIButton (Signal)

- (void)setSignal:(NSString *)signal
{
    [super setSignal:signal];
    
    [self addTarget:self action:@selector(_signal_click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_signal_click:(id)sender
{
    [self sendSignal:UIControl.click];
}

@end

