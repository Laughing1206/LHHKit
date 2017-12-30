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

/**
 * 
 * Parse URL into scheme, params and query.
 *
 * scheme://param/param?query=value&query=value
 *
 *	Example:
 *	
 *	RouterParser * parser = [[RouterParser alloc] initWithPattern:@"/:resource/:resourceId"];
 *	RouterResult * result = [parser parseString:@"app://plans/19?action=cancel"];
 *
 *	// Do sth with the result
 *	result.scheme					: app
 *	result.params[@"resource"]		: plans
 *	result.params[@"resourceId"]	: 19
 *	result.query[@"action"]			: cancel
 *
 *  More :
 *
 *	@"http://www.baidu.com"
 *  @"app://plans/19/"
 *  @"app:///plans/19/"
 *  @"app://plans/19?action=cancel"
 *  @"app://plans/19/?action=cancel"
 *
 *	TODO:
 *	https://github.com/alexmingoia/koa-router/blob/master/lib/router.js
 *
 */

@interface RouterResult : NSObject
@property (nonatomic, strong, readonly)	NSString     * url;
@property (nonatomic, strong, readonly) NSString     * scheme;
@property (nonatomic, strong, readonly) NSDictionary * params;
@property (nonatomic, strong, readonly) NSDictionary * query;
@end

@interface RouterParser : NSObject

@property (nonatomic, strong, readonly) NSString * pattern;

- (instancetype)initWithPattern:(NSString *)pattern;
+ (instancetype)parserWithPattern:(NSString *)pattern;

- (RouterResult *)parseString:(NSString *)string;

@end
