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


#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)setCircle:(NSString *)url
{
    @weakify(self);
    [self sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        self.image = image ?[image circleImage] : nil;
    }];
}

- (void)setImgWithURL:(NSString *)url
     placeholderImage:(UIImage *)placeholderImage
           beforeMode:(UIViewContentMode)beforeMode
            afterMode:(UIViewContentMode)afterMode
{
    if ([url isNoEmpty])
    {
        self.contentMode = beforeMode;
        [self sd_setImageWithURL:[NSURL URLWithString:[url APPImgURL]] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image)
            {
                self.contentMode = afterMode;
            }
        }];
    }
    else
    {
        self.contentMode = beforeMode;
        self.image = placeholderImage;
    }
}
@end
