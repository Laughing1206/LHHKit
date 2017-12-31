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

#import "ServiceNetworkLogActivity.h"
#import "ServiceNetwork.h"
#import "RouterParser.h"
#import "AFNetworking.h"
#import "AFURLResponseSerialization.h"
#import "TradeEncryption.h"

@interface ServiceNetworkLogActivity ()
@property (nonatomic, strong) IBOutlet UIWebView * webView;
@end

@implementation ServiceNetworkLogActivity

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self loadata];
}

#pragma mark -

- (void)loadata
{
	ServiceNetworkLog * log = self.data;

	if ( log )
	{
		NSURLRequest * request = log.request;
		NSURLResponse * response = log.response;
		NSError * error = log.error;

		if ( request )
		{
			self.navigationItem.title = response.URL.relativePath;
		}

		id body = nil;

        if ( [request HTTPBody] )
        {
            NSError * error = nil;
			
            body = [NSJSONSerialization JSONObjectWithData:[request HTTPBody] options:0 error:&error];

            if ( error )
            {
                body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
            }
		}

        if ([body rangeOfString:@"="].location != NSNotFound ||
            [body rangeOfString:@"&"].location != NSNotFound)
        {
            NSMutableDictionary * bodyDic = [NSMutableDictionary dictionary];
            [bodyDic removeAllObjects];
            NSArray * bodyArray = [body componentsSeparatedByString:@"&"];
            for (NSString * subBody in bodyArray)
            {
                NSArray * subBodyArray = [subBody componentsSeparatedByString:@"="];
                [bodyDic setObject:[subBodyArray lastObject] forKey:[subBodyArray firstObject]];
            }
            if (bodyDic.count)
            {
                body = [self urlDecodedString:[bodyDic JSONStringRepresentation]];
                body = [body JSONDecoded];
            }
        }
        
        
		if ( !body ) {
			RouterParser * router = [RouterParser parserWithPattern:@"/"];
			RouterResult * result = [router parseString:[response URL].absoluteString];
			body = result.query;
		}

		if ( !body )
		{
			body = @"null";
		}

		NSMutableDictionary * api = [NSMutableDictionary dictionary];

		// Handle request
		NSMutableDictionary * req  = [NSMutableDictionary dictionary];
		req[@"method"] = [request HTTPMethod];
		req[@"endpoint"] = request.URL.relativePath ;
		req[@"header"] = [request allHTTPHeaderFields];

        req[@"body"] = body ?: @"";

		// Set request of api
        [api setValue:req forKey:@"request"];

		// Handle response and error
		NSInteger statusCode = 0;

		if ( response )
		{
			NSMutableDictionary * resp = [NSMutableDictionary dictionary];
			
			if ( [response isKindOfClass:NSHTTPURLResponse.class] ) 
			{
				statusCode = [(NSHTTPURLResponse *)response statusCode];
				id headers = [(NSHTTPURLResponse *)response allHeaderFields];
				if ( headers )
				{
					[resp setValue:headers forKey:@"header"];	
				}
			}

			if ( log.responseObject && ([log.responseObject isKindOfClass:[NSDictionary class]] || [log.responseObject isKindOfClass:[NSMutableDictionary class]]) )
			{
                //*********
                //解密-------
                // 请求成功，解析数据
                NSDictionary * responseJson;

				NSString * json = [log.responseObject JSONStringRepresentation];

                responseJson = [json JSONDecoded];

                resp[@"body"] = responseJson;
                //***************
			}
			
			// Set response of api
			api[@"response"] = resp;
		}
        
		if ( error )
		{
			if ( !response )
			{
				statusCode = error.code;
			}
			
			NSMutableDictionary * responseError  = [NSMutableDictionary dictionary];
			
			[responseError setValue:error.localizedDescription forKey:@"message"];
			[responseError setValue:@(error.code) forKey:@"code"];
			
			NSData * responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
			
			if ( !responseData )
			{
				responseData = log.userInfo[AFNetworkingTaskDidCompleteResponseDataKey];
			}
			
			if ( responseData )
			{
				NSString * responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
				
				[responseError setValue:responseString forKey:@"body"];
			}
			
			[api setValue:responseError forKey:@"error"];
		}
		
		// Handle api
		api[@"url"] = request.URL.absoluteString;
		api[@"status"] = @(statusCode);
		api[@"duration"] = @(log.elapsedTime);
        
        // bytes
        api[@"sendByte"] = log.sendByte;
        api[@"receiveByte"] = log.receiveByte;
        api[@"totalByte"] = log.totalByte;

		NSBundle * bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ServiceNetworkLogActivity" ofType:@"bundle"]];
		NSString * html = [NSString stringWithContentsOfFile:[bundle pathForResource:@"index.html" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
		NSData * data = [NSJSONSerialization dataWithJSONObject:api options:NSJSONWritingPrettyPrinted error:nil];
		NSString * json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		html = [html stringByReplacingOccurrencesOfString:@"{json}" withString:json];
		
		[self.webView loadHTMLString:html baseURL:bundle.bundleURL];
	}
}

- (IBAction)close:(id)sender
{
	[[ServiceNetwork sharedServiceNetwork] hide];
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString*)urlDecodedString:(NSString *)string {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CFStringRef decodedCFString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (__bridge CFStringRef) string,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
#pragma clang diagnostic pop
    
    NSString * decodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) decodedCFString];
    return (!decodedString) ? @"" : [decodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

@end
