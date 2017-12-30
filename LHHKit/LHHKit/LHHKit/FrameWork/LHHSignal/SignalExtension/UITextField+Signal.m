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
#import "UITextField+Signal.h"

@implementation UITextField (Signal)

- (void)setSignal:(NSString *)signal
{
    [super setSignal:signal];
    
    [self addTarget:self action:@selector(_signal_editingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(_signal_editingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)_signal_editingChanged:(id)sender
{
    [self sendSignal:self.editingChanged withObject:sender];
}

- (void)_signal_editingDidEnd:(id)sender
{
    [self sendSignal:self.editingDidEnd withObject:sender];
}

@end
