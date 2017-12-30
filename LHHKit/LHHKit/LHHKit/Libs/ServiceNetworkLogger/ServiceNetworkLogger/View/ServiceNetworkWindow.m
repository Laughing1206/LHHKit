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
#import "ServiceNetworkWindow.h"
#import "ServiceNetworkActivity.h"

@implementation ServiceNetworkWindow

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		self.frame = [UIScreen mainScreen].bounds;

		UINavigationController * root = (UINavigationController *)[UIViewController loadInitialViewControllerFromStoryBoard:@"ServiceNetwork"];
		root.navigationBar.translucent = NO;
		[root.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"2a1b52"]] forBarMetrics:UIBarMetricsDefault];
		self.rootViewController = root;
	}
	return self;
}

- (void)showThen:(void (^)(BOOL))then
{
	self.alpha = 0;
    
    [self makeKeyAndVisible];
    
	[UIView animateWithDuration:0.3 animations:^ {
		self.alpha = 1;
	} completion:then];
}

- (void)hideThen:(void (^)(BOOL))then
{
	[UIView animateWithDuration:0.3 animations:^ {
		self.alpha = 0;
	} completion:then];
}

@end
