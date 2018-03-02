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

#import <UIKit/UIKit.h>

#import "UIView+Signal.h"

#pragma mark -

@interface UIControl (Signal)

/**
 *  Common UIControlEvent signal
 */
@signal(touchDown)           // UIControlEventTouchDown
@signal(touchDownRepeat)     // UIControlEventTouchDownRepeat
@signal(touchDragInside)     // UIControlEventTouchDragInside
@signal(touchDragOutside)    // UIControlEventTouchDragOutside
@signal(touchDragEnter)      // UIControlEventTouchDragEnter
@signal(touchDragExit)       // UIControlEventTouchDragExit
@signal(click)               // UIControlEventTouchUpInside
@signal(touchUpOutside)      // UIControlEventTouchUpOutside
@signal(touchCancel)         // UIControlEventTouchCancel

/**
 *  UISlider, UISwitch, UIStepper, UISegmentControl, etc.
 */
@signal(valueChanged)        // UIControlEventValueChanged

/**
 *  UITextFiled
 */
@signal(editingDidBegin)     // UIControlEventEditingDidBegin
@signal(editingChanged)      // UIControlEventEditingChanged
@signal(editingDidEnd)       // UIControlEventEditingDidEnd
@signal(editingDidEndOnExit) // UIControlEventEditingDidEndOnExit

#define touchDown
#undef  touchDown
#define touchDownRepeat
#undef  touchDownRepeat
#define touchDragInside
#undef  touchDragInside
#define touchDragOutside
#undef  touchDragOutside
#define touchDragEnter
#undef  touchDragEnter
#define touchDragExit
#undef  touchDragExit
#define click
#undef  click
#define touchUpOutside
#undef  touchUpOutside
#define touchCancel
#undef  touchCancel
#define valueChanged
#undef  valueChanged
#define editingDidBegin
#undef  editingDidBegin
#define editingChanged
#undef  editingChanged
#define editingDidEnd
#undef  editingDidEnd
#define editingDidEndOnExit
#undef  editingDidEndOnExit

@end
