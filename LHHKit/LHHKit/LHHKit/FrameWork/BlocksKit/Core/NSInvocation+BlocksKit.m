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


#import "NSInvocation+BlocksKit.h"

@interface BKInvocationGrabber : NSProxy

+ (BKInvocationGrabber *)grabberWithTarget:(id)target;

@property (nonatomic, strong) id target;
@property (nonatomic, strong) NSInvocation *invocation;

@end

@implementation BKInvocationGrabber

+ (BKInvocationGrabber *)grabberWithTarget:(id)target {
	BKInvocationGrabber *instance = [BKInvocationGrabber alloc];
	instance.target = target;
	return instance;
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
	return [self.target methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation*)invocation {
	[invocation setTarget:self.target];
	NSParameterAssert(self.invocation == nil);
	self.invocation = invocation;
}

@end


@implementation NSInvocation (BlocksKit)

+ (NSInvocation *)bk_invocationWithTarget:(id)target block:(void (^)(id target))block
{
	NSParameterAssert(block != nil);
	BKInvocationGrabber *grabber = [BKInvocationGrabber grabberWithTarget:target];
	block(grabber);
	return grabber.invocation;
}

@end
