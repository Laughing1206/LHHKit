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


#import <MessageUI/MessageUI.h>

/** MFMessageComposeViewController with block callback in addition to delegation.
 
 If you provide a completion handler to an instance of
 MFMessageComposeViewController but do not implement a delegate callback for
 messageComposeViewController:didFinishWithResult:error:, the message compose
 view controller will automatically be dismissed if it was launched modally.

 Created by [Igor Evsukov](https://github.com/evsukov89) and contributed to
 BlocksKit.

 @warning MFMessageComposeViewController is only available on a platform with MessageUI.
*/
@interface MFMessageComposeViewController (BlocksKit)

/** The block fired on the dismissal of the SMS composition interface.
 
 This block callback is an analog for the
 messageComposeViewController:didFinishWithResult: method
 of MFMessageComposeViewControllerDelegate.
 */
@property (nonatomic, copy, setter = bk_setCompletionBlock:) void (^bk_completionBlock)(MFMessageComposeViewController *controller, MessageComposeResult result);

@end
