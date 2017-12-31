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
#import "ServiceNetworkActivityCell.h"
#import "ServiceNetwork.h"

@implementation ServiceNetworkActivityCell

- (void)dataDidChange
{
	ServiceNetworkLog * log = self.data;

	NSURLRequest * request = log.request;

	NSString *body = nil;
	if ([request HTTPBody]) {
		body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
	}

	self.textLabel.text = [request URL].relativePath;
	
	if ( log.error )
	{
		if ( log.error.code == NSURLErrorCancelled )
		{
			self.detailTextLabel.textColor = [UIColor lightGrayColor];
		}
		else
		{
			self.detailTextLabel.textColor = [UIColor redColor];
		}
		
		self.detailTextLabel.text = log.error.localizedDescription;
	}
	else
	{
		self.detailTextLabel.textColor = [UIColor colorWithRed:0.03 green:0.39 blue:0.04 alpha:1];
        self.detailTextLabel.text = [log.endedAt stringFromDate];
        
	}
}

@end
