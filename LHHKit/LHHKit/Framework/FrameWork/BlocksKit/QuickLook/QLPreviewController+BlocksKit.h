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


#import <QuickLook/QuickLook.h>

@interface QLPreviewController (BlocksKit)

@property (nonatomic, copy, setter = bk_setFrameForPreviewItemInSourceView:) CGRect (^bk_frameForPreviewItem)(QLPreviewController *controller, id<QLPreviewItem>item, UIView **sourceView);

@property (nonatomic, copy, setter = bk_setTransitionImageForPreviewItem:) UIImage *(^bk_transitionImageForPreviewItem)(QLPreviewController *controller, id<QLPreviewItem> item, CGRect *contentRect);

@property (nonatomic, copy, setter = bk_setShouldOpenURLForPreviewItem:) BOOL (^bk_shouldOpenURLForPreviewItem)(QLPreviewController *controller, NSURL *url, id<QLPreviewItem> item);

/** The block to be fired before the Quick Look controller will dismiss. */
@property (nonatomic, copy, setter = bk_setWillDismissBlock:) void (^bk_willDismissBlock)(QLPreviewController *controller);

/** The block to be fired after the Quick Look controller did dismiss. */
@property (nonatomic, copy, setter = bk_setDidDismissBlock:) void (^bk_didDismissBlock)(QLPreviewController *controller);

@end
