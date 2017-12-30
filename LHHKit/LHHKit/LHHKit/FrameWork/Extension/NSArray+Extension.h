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

@protocol NSArrayProtocol <NSObject>
@required
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
@end

#pragma mark -

typedef NSMutableArray *    (^NSArrayElementBlock)( id obj );
typedef NSComparisonResult    (^NSArrayCompareBlock)( id left, id right );

#pragma mark -

@interface NSArray(Extension) <NSArrayProtocol>

- (NSMutableArray *)head:(NSUInteger)count;
- (NSMutableArray *)tail:(NSUInteger)count;

- (NSString *)join;
- (NSString *)join:(NSString *)delimiter;

- (id)safeObjectAtIndex:(NSUInteger)index;
- (id)safeSubarrayWithRange:(NSRange)range;
- (id)safeSubarrayFromIndex:(NSUInteger)index;
- (id)safeSubarrayWithCount:(NSUInteger)count;

/**
 *  数组转字符串
 */
- (NSString *)stringWithIdentifier:(NSString *)identifier;


/**
 *  数组比较
 */
- (BOOL)compareIgnoreObjectOrderWithArray:(NSArray *)array;


/**
 *  数组计算交集
 */
- (NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArray;

/**
 *  数据计算差集
 */
- (NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArray;
@end
