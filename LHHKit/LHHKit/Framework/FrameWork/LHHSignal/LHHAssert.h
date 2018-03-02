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

#pragma mark -

#define ASSERT( __expr ) [[LHHAsserter sharedLHHAsserter] file:__FILE__ line:__LINE__ func:__PRETTY_FUNCTION__ flag:((__expr) ? YES : NO) expr:#__expr];

#pragma mark -

/**
 *  断言
 */

@interface LHHAsserter : NSObject

SingletonInterface(LHHAsserter)

@prop_assign( BOOL,    enabled );

/**
 *  若已開啟則關閉，若已關閉則開啟
 */

- (void)toggle;

/**
 *  開啟，使之有效
 */

- (void)enable;

/**
 *  關閉，使之失效
 */

- (void)disable;

/**
 *  觸發斷言
 *
 *  @param file 文件名稱
 *  @param line 文件行號
 *  @param func 方法名稱
 *  @param flag 斷言結果
 *  @param expr 斷言表達式
 */

- (void)file:(const char *)file line:(NSUInteger)line func:(const char *)func flag:(BOOL)flag expr:(const char *)expr;

@end

#pragma mark -

#if __cplusplus
extern "C" {
#endif
    
    /**
     *  觸發斷言 · C語言方式
     *
     *  @param file 文件名稱
     *  @param line 文件行號
     *  @param func 方法名稱
     *  @param flag 斷言結果
     *  @param expr 斷言表達式
     */
    
    void LHHAssert( const char * file, NSUInteger line, const char * func, BOOL flag, const char * expr );
    
#if __cplusplus
}
#endif

