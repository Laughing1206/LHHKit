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
#import "MenuCell.h"

@implementation MENU_INFO

@end

@interface MenuCell ()
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView * headImageView;

@property (weak, nonatomic) IBOutlet UIImageView * bgImageView;
@end

@implementation MenuCell

- (void)awakeFromNib
{
	[super awakeFromNib];
}

- (void)dataDidChange
{
	if ( [self.data isKindOfClass:[MENU_INFO class]] )
	{
		MENU_INFO * info = self.data;
		self.titleLabel.text = info.title;
		self.headImageView.image = info.image;
		self.bgImageView.image = info.bgImage;
	}
}

@end
