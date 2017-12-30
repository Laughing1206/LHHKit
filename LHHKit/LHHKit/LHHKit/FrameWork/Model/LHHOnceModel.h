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
#import "LHHReadModel.h"

/**
 *  获取数据回调 Block
 *
 *  data    新增数据，如果获取整个列表，可以
 *  changed 数据是否与上次一样
 *  error   错误信息，如果不为空，则说明出错
 */

typedef void (^OnceModelBlock)(id error);

/**
 *  用于拉取不需要分页的数据，比如：详情等
 */
@interface LHHOnceModel : LHHReadModel

@property (nonatomic, strong) id item;

/**
 *  获取数据回调 Block
 */
@property (nonatomic, copy) OnceModelBlock whenUpdated;

@end

