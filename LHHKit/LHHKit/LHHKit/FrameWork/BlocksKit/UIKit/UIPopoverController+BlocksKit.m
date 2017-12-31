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


#import "A2DynamicDelegate.h"
#import "NSObject+A2BlockDelegate.h"
#import "UIPopoverController+BlocksKit.h"

#pragma mark - Delegate

@interface A2DynamicUIPopoverControllerDelegate : A2DynamicDelegate <UIPopoverControllerDelegate>

@end

@implementation A2DynamicUIPopoverControllerDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
	BOOL should = YES;
	
	id realDelegate = self.realDelegate;
	if (realDelegate && [realDelegate respondsToSelector:@selector(popoverControllerShouldDismissPopover:)])
		should &= [realDelegate popoverControllerShouldDismissPopover:popoverController];
	
	BOOL (^block)(UIPopoverController *) = [self blockImplementationForMethod:_cmd];
	if (block) should &= block(popoverController);
	
	return should;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	id realDelegate = self.realDelegate;
	if (realDelegate && [realDelegate respondsToSelector:@selector(popoverControllerDidDismissPopover:)])
		[realDelegate popoverControllerDidDismissPopover:popoverController];
	
	void (^block)(UIPopoverController *) = [self blockImplementationForMethod:_cmd];
	if (block) block(popoverController);
}
#pragma clang diagnostic pop
@end

#pragma mark - Category

@implementation UIPopoverController (BlocksKit)

@dynamic bk_didDismissBlock, bk_shouldDismissBlock;

+ (void)load
{
	@autoreleasepool {
		[self bk_registerDynamicDelegate];
		[self bk_linkDelegateMethods:@{ @"bk_didDismissBlock": @"popoverControllerDidDismissPopover:", @"bk_shouldDismissBlock": @"popoverControllerShouldDismissPopover:" }];
	}
}

@end
