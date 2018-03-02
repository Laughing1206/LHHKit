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

/** UIImagePickerController with block callback.

 Created by [Yas Kuraishi](https://github.com/YasKuraishi) and contributed to
 BlocksKit.

 @warning UIImagePickerController is only available on a platform with
 UIKit.
*/
@interface UIImagePickerController (BlocksKit)

/**
 *	The block that fires after the receiver finished picking up an image
 */
@property (nonatomic, copy) void(^bk_didFinishPickingMediaBlock)(UIImagePickerController *, NSDictionary *);

/**
 *	The block that fires after the user cancels out of picker
 */
@property (nonatomic, copy) void(^bk_didCancelBlock)(UIImagePickerController *);

@end
