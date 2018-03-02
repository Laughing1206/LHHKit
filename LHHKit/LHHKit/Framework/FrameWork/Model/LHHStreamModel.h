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
 *  @param error   错误信息，如果不为空，则说明出错
 */
typedef void (^StreamModelBlock)(id error);

@interface LHHStreamModel : LHHReadModel

/**
 *  是否还有更多数据，用于上拉加载更多等场景
 */
@property (nonatomic, assign) BOOL more;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray * items;

/**
 *  获取数据回调 Block
 */
@property (nonatomic, copy) StreamModelBlock whenUpdated;

/**
 *  加载跟多数据
 */
- (void)loadMore;

@end

