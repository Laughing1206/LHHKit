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

#import "UIControl+Signal.h"

// ----------------------------------
// Source code
// ---------------------------------

@implementation UIControl (Signal)

@def_signal(touchDown)           // UIControlEventTouchDown
@def_signal(touchDownRepeat)     // UIControlEventTouchDownRepeat
@def_signal(touchDragInside)     // UIControlEventTouchDragInside
@def_signal(touchDragOutside)    // UIControlEventTouchDragOutside
@def_signal(touchDragEnter)      // UIControlEventTouchDragEnter
@def_signal(touchDragExit)       // UIControlEventTouchDragExit
@def_signal(click)               // UIControlEventTouchUpInside
@def_signal(touchUpOutside)      // UIControlEventTouchUpOutside
@def_signal(touchCancel)         // UIControlEventTouchCancel

@def_signal(valueChanged)        // UIControlEventValueChanged

@def_signal(editingDidBegin)     // UIControlEventEditingDidBegin
@def_signal(editingChanged)      // UIControlEventEditingChanged
@def_signal(editingDidEnd)       // UIControlEventEditingDidEnd
@def_signal(editingDidEndOnExit) // UIControlEventEditingDidEndOnExit

//- (void)setSignal:(NSString *)signal
//{
//    [super setSignal:signal];

//    [self addTarget:self action:@selector(_signal_touchDown:) forControlEvents:UIControlEventTouchDown];
//    [self addTarget:self action:@selector(_signal_touchDownRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
//    [self addTarget:self action:@selector(_signal_touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
//    [self addTarget:self action:@selector(_signal_touchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
//    [self addTarget:self action:@selector(_signal_touchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
//    [self addTarget:self action:@selector(_signal_touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
//    [self addTarget:self action:@selector(_signal_click:) forControlEvents:UIControlEventTouchUpInside];
//    [self addTarget:self action:@selector(_signal_touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
//    [self addTarget:self action:@selector(_signal_touchCancel:) forControlEvents:UIControlEventTouchCancel];
//    [self addTarget:self action:@selector(_signal_valueChanged:) forControlEvents:UIControlEventValueChanged];
//    [self addTarget:self action:@selector(_signal_editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
//    [self addTarget:self action:@selector(_signal_editingChanged:) forControlEvents:UIControlEventEditingChanged];
//    [self addTarget:self action:@selector(_signal_editingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
//    [self addTarget:self action:@selector(_signal_editingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
//}

//- (void)_signal_touchDown:(id)sender
//{
//    [self sendSignal:UIControl.touchDown];
//}
//
//- (void)_signal_touchDownRepeat:(id)sender
//{
//    [self sendSignal:UIControl.touchDownRepeat];
//}
//
//- (void)_signal_touchDragInside:(id)sender
//{
//    [self sendSignal:UIControl.touchDragInside];
//}
//
//- (void)_signal_touchDragOutside:(id)sender
//{
//    [self sendSignal:UIControl.touchDragOutside];
//}
//
//- (void)_signal_touchDragEnter:(id)sender
//{
//    [self sendSignal:UIControl.touchDragEnter];
//}
//
//- (void)_signal_touchDragExit:(id)sender
//{
//    [self sendSignal:UIControl.touchDragExit];
//}
//
//- (void)_signal_click:(id)sender
//{
//    [self sendSignal:UIControl.click];
//}
//
//- (void)_signal_touchUpOutside:(id)sender
//{
//    [self sendSignal:UIControl.touchUpOutside];
//}
//
//- (void)_signal_touchCancel:(id)sender
//{
//    [self sendSignal:UIControl.touchCancel];
//}
//
//- (void)_signal_valueChanged:(id)sender
//{
//    [self sendSignal:UIControl.valueChanged];
//}
//
//- (void)_signal_editingDidBegin:(id)sender
//{
//    [self sendSignal:UIControl.editingDidBegin];
//}
//
//- (void)_signal_editingChanged:(id)sender
//{
//    [self sendSignal:UIControl.editingChanged];
//}
//
//- (void)_signal_editingDidEnd:(id)sender
//{
//    [self sendSignal:UIControl.editingDidEnd];
//}
//
//- (void)_signal_editingDidEndOnExit:(id)sender
//{
//    [self sendSignal:UIControl.editingDidEndOnExit];
//}

@end
