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

#import "RouterParser.h"

@interface RouterResult ()
@property (nonatomic, strong) NSString		* url;
@property (nonatomic, strong) NSString		* scheme;
@property (nonatomic, strong) NSDictionary	* params;
@property (nonatomic, strong) NSDictionary	* query;
@end

@implementation RouterResult

- (NSString *)description
{
	return [NSString stringWithFormat:@"\nurl:%@\nscheme:%@\nparams:%@\nquery:%@", _url, _scheme, _params, _query];
}

@end

#pragma mark -

@interface RouterParser ()
@property (nonatomic, strong) NSMutableArray * paramKeys;
@end

@implementation RouterParser

+ (instancetype)parserWithPattern:(NSString *)pattern
{
	return [[RouterParser alloc] initWithPattern:pattern];
}

- (instancetype)initWithPattern:(NSString *)pattern
{
	self = [super init];
	if (self)
    {
		_pattern = pattern;
		_paramKeys = [NSMutableArray array];
		[self parsePattern:pattern];
	}
	return self;
}

// /:param/:param/:param/:param
- (void)parsePattern:(NSString *)pattern
{
	// Trim the ':' and '/'
	pattern = [pattern stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/:"]];

	NSArray * paramKeys = [pattern componentsSeparatedByString:@"/"];

	[paramKeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
		if ( [obj hasPrefix:@":"] )
        {
			obj = [obj substringFromIndex:1];
		}
		[self.paramKeys addObject:obj];
	}];
}

#pragma mark -

// /param/param/param/param/param
- (RouterResult *)parseString:(NSString *)string
{
	RouterResult * reslut = [RouterResult new];
	reslut.url = string;
	
	NSString * url = [string copy];
	
	NSString * seprator = @"://";
	
	// Find scheme
	NSRange range = [url rangeOfString:seprator];
	
	if ( range.location == NSNotFound )
		return reslut;

	reslut.scheme = [url substringToIndex:range.location];

	// Consumed scheme
	NSString * last = [url substringFromIndex:range.location + seprator.length];

	// Before finding parmas, check whether the query exists first
	seprator = @"?";
	range = [last rangeOfString:seprator];

	// if exits, substring
	NSString * params = [last copy];
	
	if ( range.location != NSNotFound )
	{
		params = [params substringToIndex:range.location];
		last = [last substringFromIndex:range.location + seprator.length];
	}
	
	params = [params stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
	
	NSArray * components = [params componentsSeparatedByString:@"/"];
	
	if ( components.count )
	{
//		if ( components.count != self.paramKeys.count )
//		{
//			NSLog(@"『WARNINIG - RouterParser.h 』The URL: '%@' not matches the specified pattern: '%@'", url, self.pattern);
//		}
		
		NSMutableDictionary * params = [NSMutableDictionary dictionary];
		
		[components enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop)
		 {
			 NSString * paramKey = nil;
			 
			 if ( idx < self.paramKeys.count )
             {
				 paramKey = self.paramKeys[idx];
			 }
			 
			 if ( !paramKey )
             {
				 paramKey = [NSString stringWithFormat:@"%tu", idx];
			 }
			 
			 if ( obj )
             {
				 params[paramKey] = obj;
			 }
		 }];
		
		reslut.params = params;
	}
	
	if ( range.location != NSNotFound )
	{
		// ?query=value&query=value
		
		NSArray * components = [last componentsSeparatedByString:@"&"];
		
		if ( components.count )
		{
			NSMutableDictionary * query = [NSMutableDictionary dictionary];
			
			[components enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop)
			 {
				 NSArray * pairs = [obj componentsSeparatedByString:@"="];
				 
				 if ( pairs.count == 2 )
				 {
					 query[pairs[0]] = pairs[1];
				 }
				 else if ( pairs.count == 1 )
				 {
					 query[pairs[0]] = @"";
				 }
			 }];
			
			reslut.query = query;
		}
	}
	
	return reslut;
}

@end
