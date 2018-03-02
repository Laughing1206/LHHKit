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
#import <Foundation/Foundation.h>
#import "LHHSignal.h"

@interface LHHSignalBus : NSObject

SingletonInterface(LHHSignalBus)

- (BOOL)send:(LHHSignal *)signal;
- (BOOL)forward:(LHHSignal *)signal;
- (BOOL)forward:(LHHSignal *)signal to:(id)target;

- (void)routes:(LHHSignal *)signal;
- (void)routes:(LHHSignal *)signal to:(NSObject *)target forClasses:(NSArray *)classes;


@end
