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


#import "AppTheme.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "Aspects.h"
#import <WebKit/WebKit.h>
#import "ZLPhotoActionSheet.h"
#import "AppSesseionManager.h"
#import "TradeEncryption.h"

@implementation AppTheme

SingletonImplemention( AppTheme )

+ (NSDictionary *)styleClass
{
    NSDictionary * dicts = @{
                             @"color" : @{
                                     @"c0" : [UIColor colorWithRGBValue:0x252525],
                                     @"c1" : [UIColor colorWithRGBValue:0x5a5a5a],
                                     @"c2" : [UIColor colorWithRGBValue:0xe91a2a],
                                     @"c3" : [UIColor colorWithRGBValue:0xff404e],
                                     @"c4" : [UIColor colorWithRGBValue:0xa2a1a1],
                                     @"c5" : [UIColor colorWithRGBValue:0x317ef3],
                                     @"c6" : [UIColor colorWithRGBValue:0x6b6b6b],
                                     },
                             @"font" : @{
                                     @"h0" : [UIFont systemFontOfSize:17],
                                     @"h1" : [UIFont systemFontOfSize:15],
                                     @"h2" : [UIFont systemFontOfSize:14],
                                     @"h3" : [UIFont systemFontOfSize:12],
                                     @"h4" : [UIFont systemFontOfSize:10],
                                     @"h5" : [UIFont systemFontOfSize:16],
                                     @"h6" : [UIFont systemFontOfSize:11],
                                     }
                             };
    
    return dicts;
}

+ (void)setupAppearanceWithViewController:(UITabBarController *)vc
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[self mainColor]]forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:[AppTheme titleColor],
                                                           NSFontAttributeName: [UIFont systemFontOfSize:18]
                                                           }];
    [[UITabBar appearance] setTintColor:[AppTheme mainColor]];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName : [UIColor colorWithRGBValue:0x9b9b9b]
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName : [UIColor colorWithRGBValue:0x327ff3]
                                                        } forState:UIControlStateSelected];
    if (vc)
    {
        UINavigationController *nav = vc.childViewControllers[0];
        [nav.navigationBar setTintColor:[UIColor whiteColor]];
        
        [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:[self mainColor]]forBarMetrics:UIBarMetricsDefault];
        [nav.navigationBar setTitleTextAttributes:@{
                                                                        NSForegroundColorAttributeName:[AppTheme titleColor],
                                                                        NSFontAttributeName: [UIFont systemFontOfSize:18]
                                                                        }];
        [vc.tabBar setTintColor:[AppTheme mainColor]];
        
        [vc.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        
        [vc.tabBarItem setTitleTextAttributes:@{
                                                                 NSForegroundColorAttributeName : [UIColor colorWithRGBValue:0x9b9b9b]
                                                                 } forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{
                                                                 NSForegroundColorAttributeName : [UIColor colorWithRGBValue:0x327ff3]
                                                                 } forState:UIControlStateSelected];
    }
}

+ (void)adaptToiPad
{
    NSError * error;
    
    [UIViewController aspect_hookSelector:@selector(awakeFromNib)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo) {
                                   UIViewController * vc = aspectInfo.instance;
                                   vc.preferredContentSize = CGSizeZero;
                               } error:&error];
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo) {
                                   UIViewController * vc = aspectInfo.instance;
                                   
                                   if ( CGSizeEqualToSize(vc.preferredContentSize, CGSizeZero) )
                                   {
                                       vc.preferredContentSize = [AppTheme preferredContentSize];
                                   }
                               } error:&error];
    
}

+ (UIColor *)mainColor
{
    return [UIColor colorWithRGBValue:0xF9F9F9];
}

+ (UIColor *)titleColor
{
    return [UIColor colorWithRGBValue:0x323741];
}

+ (UIColor *)subTitleColor
{
    return [UIColor colorWithRGBValue:0x9D99A];
}

+ (UIColor *)mainBackgroundColor
{
    return [UIColor colorWithRGBValue:0xF5F5F5];
}

+ (UIColor *)lineColor
{
    return [UIColor colorWithRGBValue:0xE5E1E1];
}

+ (UIFont *)cn16SizeRegularFont
{
	return [[self class] cnRegularFont:16];
}

+ (UIFont *)cn14SizeRegularFont
{
	return [[self class] cnRegularFont:14];
}

+ (UIFont *)cnRegularFont:(NSUInteger)size
{
	return [UIFont systemFontOfSize:size];
}

#pragma mark - Placeholder

static UIImage * kPlaceholderImage;

+ (void)setPlaceholderImage:(UIImage *)image
{
    kPlaceholderImage = [UIImage imageNamed:@"placeholder"];
}

+ (UIImageView *)placeholderView
{
    return [[UIImageView alloc] initWithImage:kPlaceholderImage];
}

+ (UITableViewCell *)placeholderTableViewCell
{
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    UIImageView * view = [self placeholderView];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:[self placeholderView]];
    return cell;
}

+ (UICollectionViewCell *)placeholderCollectionViewCell
{
    UICollectionViewCell * cell = [[UICollectionViewCell alloc] init];
    UIImageView * view = [self placeholderView];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:[self placeholderView]];
    return cell;
}

#pragma mark - Line

+ (CGFloat)onePixel
{
    static CGFloat one;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        one = 1 / [UIScreen mainScreen].scale;
    });
    return one;
}

+ (void)onePixelizes:(NSArray *)constraints
{
    [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * obj, NSUInteger idx, BOOL *stop) {
        obj.constant = [AppTheme onePixel];
    }];
}

#pragma mark -

+ (CGSize)preferredContentSize
{
    return CGSizeMake(500, 665);
}

#pragma mark - UINavigationBarItem

+ (UIBarButtonItem *)itemWithContent:(id)content handler:(void (^)(id))handler
{
    UIBarButtonItem * item = nil;

    if ( [content isKindOfClass:[NSString class]] )
    {
        item = [[UIBarButtonItem alloc] bk_initWithTitle:content style:UIBarButtonItemStylePlain handler:handler];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
        item.tintColor = [UIColor colorWithHexString:@"FFFFFF"];
    }
    else if ( [content isKindOfClass:[UIImage class]] )
    {
        item = [[UIBarButtonItem alloc] bk_initWithImage:[(UIImage *)content imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain handler:handler];
    }
    else if ( [content isKindOfClass:[UIButton class]] )
    {
        item = [[UIBarButtonItem alloc] bk_initWithButton:content handler:handler];
    }
	else
	{
		item = [[UIBarButtonItem alloc] bk_initWithTitle:@"" style:UIBarButtonItemStylePlain handler:handler];
		item.tintColor = [UIColor colorWithHexString:@"55595F"];
	}

    return item;
}

+ (UIBarButtonItem *)backItemWithHandler:(void (^)(id sender))handler
{
    UIBarButtonItem * item = [self itemWithContent:[UIImage imageNamed:@"back"] handler:handler];
	[item setImageInsets:UIEdgeInsetsMake(5, -3, 0, 0)];
    return item;
}

+ (UIBarButtonItem *)backModalWithHandler:(void (^)(id sender))handler
{
    UIBarButtonItem * item = [self itemWithContent:[UIImage imageNamed:@"login_close"] handler:handler];
    [item setImageInsets:UIEdgeInsetsMake(0, -7, 0, 0)];
    return item;
}

+ (UIBarButtonItem *)loginItemWithTitle:(NSString *)title Handler:(void (^)(id sender))handler
{
	UIBarButtonItem * item = [self itemWithContent:title handler:handler];
	return item;
}

+ (UIBarButtonItem *)editItemWithTitle:(NSString *)title Handler:(void (^)(id sender))handler
{
    UIBarButtonItem * item = [self itemWithContent:title handler:handler];
    return item;
}

+ (UIBarButtonItem *)shareItemWithHandler:(void (^)(id sender))handler
{
    UIBarButtonItem * item = [self itemWithContent:[UIImage imageNamed:@"b2_share"] handler:handler];
    item.tintColor = [UIColor whiteColor];
    return item;
}

+ (UIBarButtonItem *)setupItemWithHandler:(void (^)(id sender))handler
{
    UIBarButtonItem * item = [self itemWithContent:[UIImage imageNamed:@"home_set"] handler:handler];
    item.tintColor = [UIColor whiteColor];
    return item;
}

+ (UIBarButtonItem *)whiteItemWithTitle:(NSString *)title Handler:(void (^)(id sender))handler
{
	UIBarButtonItem * item = [self itemWithContent:title handler:handler];
	return item;
}

+ (NSAttributedString *)attributedPlaceholderWithString:(NSString *)string
{
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:string
                                                                            attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"BBBBBB"],NSFontAttributeName:[UIFont systemFontOfSize:13.f]
                                                                                         }];
    return attributedString;
}

+ (UITabBarItem *)itemWithImage:(UIImage *)image selectImage:(UIImage *)selectImage title:(NSString *)title
{
	UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectImage];

	item.image = image;
	item.selectedImage = selectImage;
	
	item.title = title;

	if( !(title && title.length) )
	{
		item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
	}

	return item;
}

+ (UITabBarItem *)itemWithImageName:(NSString *)imageName selectImageName:(NSString *)selectImageName title:(NSString *)title
{
    UIImage * home  = [UIImage imageNamed:imageName];
    UIImage * homeS = [UIImage imageNamed:selectImageName];
    
    UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:title image:home selectedImage:homeS];
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRGBValue:0x9b9b9b]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRGBValue:0x327ff3]} forState:UIControlStateSelected];

    item.image = [home imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [homeS imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //	item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    return item;
}

#pragma LableFrame

+ (CGRect)estimateTitleLableFrameWithString:(NSString *)title
                                       size:(CGSize)size
{
    NSAttributedString * str = [self getTitleAttributedString:title];
    
    CGRect labelFrame = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    labelFrame.size.height = ceil(labelFrame.size.height);
    
    if ( labelFrame.size.height < 12 )
    {
        labelFrame.size.height = 12 ;
    }
    else
    {
        labelFrame.size.height = labelFrame.size.height + 12;
    }
    
    return labelFrame;
}

+ (NSAttributedString *)getTitleAttributedString:(NSString *)str
{
    if ( str == nil )
    {
        return nil;
    }

    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:str
																			attributes:@{ NSFontAttributeName : [self detailTitleFont], NSParagraphStyleAttributeName : [self detailParagraphStyle]}];

    return attributedString;
}

+ (UIFont *)detailTitleFont
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return [UIFont systemFontOfSize:15];
    }
    else
    {
        return [UIFont systemFontOfSize:12];
    }
}

+ (UIFont *)orderResultTextFont
{
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)productListTextFont
{
    return [UIFont systemFontOfSize:15];
}

+ (NSMutableParagraphStyle *)detailParagraphStyle
{
    // 设置段落样式
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 0.f; //开头缩排
    paragraphStyle.headIndent = 0.f; //左边 padding
    paragraphStyle.tailIndent = 0.f; //右边 padding
    paragraphStyle.lineSpacing = 5.f; //行距
    paragraphStyle.paragraphSpacing = 0.f;
    paragraphStyle.paragraphSpacingBefore = 0.f;

    return paragraphStyle;
}

#pragma mark - Placeholder

+ (UIImage *)placeholderImage
{
    return [UIImage imageNamed:@"default_image_01"];
}

+ (UIImage *)buildingPlaceholderImage
{
    return [UIImage imageWithColor:[UIColor colorWithRGBValue:0x403a39]];
}

#pragma mark - PriceString

+ (NSString *)priceWithString:(NSString *)string
{
    NSString *str = [NSString string];
    return [str stringWithNum:string];
}

+ (void)presentViewController:(UIViewController *)controller inViewController:(UIViewController *)container
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UINavigationController * nav = \
        [[UINavigationController alloc] initWithRootViewController:controller];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIPopoverController * pop = [[UIPopoverController alloc] initWithContentViewController:nav];
#pragma clang diagnostic pop
        
        [pop presentPopoverFromRect:container.view.frame
                             inView:container.view
           permittedArrowDirections:0
                           animated:YES];
    }
    else
    {
        [container.navigationController pushViewController:controller animated:YES];
    }
}

// splash广告页倒计时的样式字符串
+ (NSMutableAttributedString *)countdownAttributedString:(NSString *)str
{
	// 单位为秒，所以字符串分割位置在总字符长度-1的位置(每公里用时)
	return [self attributedString:str
					 withLocation:str.length - 1
						leadColor:[[self class] mainColor]
						 leadFont:[[self class] cn16SizeRegularFont]
					   trailColor:[UIColor whiteColor]
						trailFont:[[self class] cn16SizeRegularFont]];
}

+ (NSMutableAttributedString *)attributedString:(NSString *)str
								   withLocation:(NSUInteger)location
									  leadColor:(UIColor *)leadColor
									   leadFont:(UIFont *)leadFont
									 trailColor:(UIColor *)trailColor
									  trailFont:(UIFont *)trailFont
{
	if ( str == nil )
		return nil;
	
	NSMutableAttributedString * placeholder = nil;
	if ( str.length == location )
	{
		placeholder = [[NSMutableAttributedString alloc] initWithString:str];
		NSDictionary * attributes = @{NSForegroundColorAttributeName : leadColor, NSFontAttributeName : leadFont};
		[placeholder addAttributes:attributes range:NSMakeRange(0, location)];
	}
	else
	{
		placeholder = [[NSMutableAttributedString alloc] initWithString:str];
		NSDictionary * leadAttributes = @{NSForegroundColorAttributeName : leadColor, NSFontAttributeName : leadFont};
		[placeholder addAttributes:leadAttributes range:NSMakeRange(0, location)];
		NSDictionary * trialAttributes = @{NSForegroundColorAttributeName : trailColor, NSFontAttributeName : trailFont};
		[placeholder addAttributes:trialAttributes range:NSMakeRange(location , str.length - location)];
	}
	
	return placeholder;
}

#pragma mark - 字符串加星处理
+ (NSString *)encryptionDisplayMessageWith:(NSString *)content WithFirstIndex:(NSInteger)findex;
{
    if (findex <= 0) {
        findex = 2;
    }else if (findex + 1 > content.length) {
        findex --;
    }
    return [NSString stringWithFormat:@"%@***%@",[content substringToIndex:findex],[content substringFromIndex:content.length - 1]];
}

+ (NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

#pragma mark - base64图片转编码
+ (UIImage *)base64StrToUIImage:(NSString *)encodedImageStr
{
    NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string
                                              startRanges:(NSArray *)startRanges
                                                endRanges:(NSArray *)endRanges
                                                    fonts:(NSArray *)fonts
                                                   colors:(NSArray *)colors
                                          baselineOffsets:(NSArray *)baselineOffsets
{
    NSMutableAttributedString * attriString = [[NSMutableAttributedString alloc] initWithString:string];
    
    for ( int i = 0; i < fonts.count; i++ )
    {
        UIFont * font = [UIFont systemFontOfSize:10];
        
        if ( [fonts[i] isKindOfClass:[NSString class]] )
        {
            NSString * fontStr = fonts[i];
            font = [UIFont systemFontOfSize:fontStr.floatValue];
        }
        else
        {
            font = fonts[i];
        }
        
        UIColor * color = [UIColor blackColor];
        
        if ( [colors[i] isKindOfClass:[NSString class]] )
        {
            NSString * colorStr = colors[i];
            color = [UIColor colorWithHexString:colorStr];
        }
        else
        {
            color = colors[i];
        }
        
        NSNumber * startIndex = startRanges[i];
        NSNumber * endIndex = endRanges[i];
        NSRange range = NSMakeRange( startIndex.floatValue, endIndex.floatValue);
        NSNumber * baselineOffset = baselineOffsets[i];
        
        [attriString addAttributes:@{
                                     NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:color,
                                     NSBaselineOffsetAttributeName : baselineOffset
                                     }
                             range:range];
    }
    
    return attriString;
}


+ (void)telWithPhone:(NSString *)phoneNumber on:(UIViewController *)owner;
{
    if (phoneNumber && phoneNumber.length)
    {
        NSString * str = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", str]];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ( [[UIApplication sharedApplication] canOpenURL:url] && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSString * message = [NSString stringWithFormat:@"%@\n%@", @"无法拨打电话", phoneNumber];
            [[[UIAlertView alloc] initWithTitle:message
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"确认"
                              otherButtonTitles:nil] show];
        }
#pragma clang diagnostic pop
    }
    else
    {
        [ErrorHandler error:nil withTips:@"电话号码无效"];
    }
}

- (void)clearWebCache
{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                                                   modifiedSince:[NSDate dateWithTimeIntervalSince1970:0]
                                               completionHandler:^{
                                                   
                                               }];
#pragma clang diagnostic pop
    }
    else
    {
        NSString * libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES)objectAtIndex:0];
        NSError * errors;
        [[NSFileManager defaultManager]removeItemAtPath:[libraryPath stringByAppendingString:@"/Cookies"] error:&errors];
    }
}

- (void)showPhotos:(NSArray *)imgArray
             index:(NSInteger)index
       hideToolBar:(BOOL)hideToolBar
    viewController:(UIViewController *)viewController
{
    ZLPhotoActionSheet * actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.sender = viewController;
    actionSheet.configuration.navBarColor = [UIColor blackColor];
    actionSheet.configuration.navTitleColor = [UIColor whiteColor];
    [actionSheet previewPhotos:imgArray index:index hideToolBar:hideToolBar complete:^(NSArray * _Nonnull photos) {
    }];

}

+ (CGSize)calculateTextSizeWithText:(NSString *)text textFont:(CGFloat)textFont maxWidth:(CGFloat)maxWidth
{
    CGFloat textMaxW = maxWidth;
    CGSize textMaxSize = CGSizeMake(textMaxW, MAXFLOAT);
    
    CGSize textSize = [text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFont]} context:nil].size;
    
    return textSize;
}

@end
