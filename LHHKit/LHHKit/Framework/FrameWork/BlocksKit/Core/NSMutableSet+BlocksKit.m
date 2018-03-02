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


#import "NSMutableSet+BlocksKit.h"

@implementation NSMutableSet (BlocksKit)

- (void)bk_performSelect:(BOOL (^)(id obj))block {
	NSParameterAssert(block != nil);

	NSSet *list = [self objectsPassingTest:^BOOL(id obj, BOOL *stop) {
		return block(obj);
	}];

	[self setSet:list];
}

- (void)bk_performReject:(BOOL (^)(id obj))block {
	NSParameterAssert(block != nil);
	[self bk_performSelect:^BOOL(id obj) {
		return !block(obj);
	}];
}

- (void)bk_performMap:(id (^)(id obj))block {
	NSParameterAssert(block != nil);

	NSMutableSet *new = [NSMutableSet setWithCapacity:self.count];

	[self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		id value = block(obj);
		if (!value) return;
		[new addObject:value];
	}];

	[self setSet:new];
}

@end
