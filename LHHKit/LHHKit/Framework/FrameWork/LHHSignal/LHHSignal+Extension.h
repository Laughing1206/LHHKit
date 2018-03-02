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

#import "LHHSignal.h"

#undef  signal_as_source_property
#define signal_as_source_property(clz, name) \
property (nonatomic, strong, readonly) clz * name;

#undef  signal_def_source_property
#define signal_def_source_property(clz, name) \
dynamic name; \
- (clz *)name { \
SignalCheckSourceType(clz) \
return self.source; \
}

#pragma mark -

@interface LHHSignal (Extension)

@property (nonatomic, strong, readonly) id preferedSource;

@signal_as_source_property( UIView,              uiView );
@signal_as_source_property( UISlider,            uiSlider );
@signal_as_source_property( UIButton,            uiButton );
@signal_as_source_property( UISwitch,            uiSwitch );
@signal_as_source_property( UIStepper,           uiStepper );
@signal_as_source_property( UITextField,         uiInput );
@signal_as_source_property( UITextView,          uiTextArea );
@signal_as_source_property( UISegmentedControl,  uiSegment );
@signal_as_source_property( UIView,     uiCell ); // UITableViewCell or UICollectionViewCell
@end
