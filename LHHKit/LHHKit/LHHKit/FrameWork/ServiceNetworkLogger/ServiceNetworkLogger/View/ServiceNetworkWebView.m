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

#import "ServiceNetworkWebView.h"

@implementation ServiceNetworkWebView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^ {
            [self installMenuItems];
        });
    }
    return self;
}

- (void)installMenuItems
{
    UIMenuController * menuController = [UIMenuController sharedMenuController];
    NSMutableArray * items = [NSMutableArray arrayWithArray:menuController.menuItems];

    UIMenuItem * item = nil;
    
    item = [[UIMenuItem alloc] initWithTitle:@"复制文字" action:@selector(sn_copy:)];
    [items addObject:item];
    
//    item = [[UIMenuItem alloc] initWithTitle:@"全选" action:@selector(sn_selectAll:)];
//    [items addObject:item];
    
    item = [[UIMenuItem alloc] initWithTitle:@"全屏截图" action:@selector(sn_screenshot:)];
    [items addObject:item];
    
    [menuController setMenuItems:items];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ( action == @selector(sn_copy:) || action == @selector(sn_screenshot:) || action == @selector(sn_selectAll:))
        return YES;
    return NO;
}

- (void)sn_copy:(id)sender
{
    [super copy:sender];
}

- (void)sn_selectAll:(id)sender
{
    [super selectAll:sender];
}

- (void)sn_screenshot:(id)sender
{
    UIImage * image = [self imageRepresentation];
    
    [[UIPasteboard generalPasteboard] setData:UIImagePNGRepresentation(image)
                            forPasteboardType:@"public.png"];
    
    UIImageWriteToSavedPhotosAlbum(image, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
}

- (UIImage *)imageRepresentation
{
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    
    CGPoint offset = self.scrollView.contentOffset;
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    CGFloat contentHeight = self.scrollView.contentSize.height;
    NSMutableArray *images = [NSMutableArray array];

    while (contentHeight > 0) {
       UIGraphicsBeginImageContextWithOptions(boundsSize, NO, [UIScreen mainScreen].scale);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:image];
        
        CGFloat offsetY = self.scrollView.contentOffset.y;
        [self.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    [self.scrollView setContentOffset:offset];
    
    UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0, boundsHeight * idx, boundsWidth, boundsHeight)];
    }];

    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fullImage;
}

@end
