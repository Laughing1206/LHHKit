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


#import "SharedPost.h"

@implementation ACCOUNT;
@end


@implementation SharedPost

- (void)copyFrom:(SharedPost *)post
{
	if ( post.title )
	{
		self.title = post.title;
	}
	
	if ( post.text )
	{
		self.text = post.text;
	}
	
	if ( post.photo )
	{
		self.photo = post.photo;
	}
	
	if ( post.url )
	{
		self.url = post.url;
	}
}

- (void)clear
{
	self.title = nil;
	self.text = nil;
	self.photo = nil;
	self.url = nil;
}

@end
