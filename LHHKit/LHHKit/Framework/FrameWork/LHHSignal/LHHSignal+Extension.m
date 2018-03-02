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

#import "LHHSignal+Extension.h"

#undef  SignalCheckSourceType
#define SignalCheckSourceType( x ) \
NSAssert2( [self.source isKindOfClass:[x class]], @"Signal source is kind of [%@ class], but expected to be [%@ class]. You may access wrong source, please check.", [self.source class], [x class]);

static const char kSignalPreferedSourceKey;

@implementation LHHSignal(Extension)

@dynamic preferedSource;

- (void)setPreferedSource:(id)preferedSource
{
    objc_setAssociatedObject( self, &kSignalPreferedSourceKey, preferedSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (id)preferedSource
{
    return objc_getAssociatedObject(self, &kSignalPreferedSourceKey);
}

#pragma mark -

@signal_def_source_property( UIView,               uiView );
@signal_def_source_property( UISlider,             uiSlider );
@signal_def_source_property( UIButton,             uiButton );
@signal_def_source_property( UISwitch,             uiSwitch );
@signal_def_source_property( UIStepper,            uiStepper );
@signal_def_source_property( UITextField,          uiInput );
@signal_def_source_property( UITextView,           uiTextArea );
@signal_def_source_property( UISegmentedControl,   uiSegment );

@dynamic uiCell;

- (UIView *)uiCell
{
    UIView * source = self.source;
    
    if ( [source isKindOfClass:UIView.class] )
    {
        UIView * view = source.superview;
        
        while ( view )
        {
            if ( [view isKindOfClass:UITableViewCell.class] )
            {
                return view;
            }
            
            if ( [view isKindOfClass:UICollectionViewCell.class] )
            {
                return view;
            }
            
            view = view.superview;
        }
    }
    
    return nil;
}

@end

