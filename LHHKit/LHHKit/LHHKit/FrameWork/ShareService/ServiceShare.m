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


#import "ServiceShare.h"

@interface ServiceShare ()
@end

@implementation ServiceShare

SingletonImplemention(ServiceShare)

- (void)dealloc
{
	self.whenShareBegin		= nil;
	self.whenShareSucceed	= nil;
	self.whenShareFailed	= nil;
	self.whenShareCancelled	= nil;

	self.whenFollowBegin	 = nil;
	self.whenFollowSucceed	 = nil;
	self.whenFollowFailed	 = nil;
	self.whenFollowCancelled = nil;

	self.whenGetUserInfoBegin     = nil;
	self.whenGetUserInfoSucceed   = nil;
	self.whenGetUserInfoFailed	  = nil;
	self.whenGetUserInfoCancelled = nil;
}

- (void)powerOn
{
	
}

@end
