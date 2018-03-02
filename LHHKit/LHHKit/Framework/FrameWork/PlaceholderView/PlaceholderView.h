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

#import <UIKit/UIKit.h>
#import "UITableViewNoSepratorCell.h"

@interface PlaceholderTableViewCell : UITableViewNoSepratorCell
@property (nonatomic, strong) UIView * customView;
@end

@interface PlaceholderCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView * customView;
@end

@interface PlaceholderNetWorkCollectionCell : PlaceholderCollectionViewCell
@end

@interface PlaceholderNetWorkCell : PlaceholderTableViewCell
@end

@interface PlaceholderHomeCell : PlaceholderCollectionViewCell
@end

@interface PlaceholderCategoryCell : PlaceholderCollectionViewCell
@end

@interface PlaceholderGoodsListCell : PlaceholderCollectionViewCell
@end

@interface PlaceholderCartCell : PlaceholderTableViewCell
@end

@interface PlaceholderTradingCenterCell : PlaceholderTableViewCell
@end

@interface PlaceholderOrderCell : PlaceholderTableViewCell
@end

@interface PlaceholderBankCardCell : PlaceholderTableViewCell
@end

@interface PlaceholderAddressCell : PlaceholderTableViewCell
@end

@interface PlaceholderBrowseCell : PlaceholderTableViewCell
@end

@interface PlaceholderCollectionGoodsCell : PlaceholderTableViewCell
@end

@interface PlaceholderRecordCell : PlaceholderTableViewCell
@end

@interface PlaceholderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *subtitleLable;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewActionBtnTopSpace;

+ (instancetype)viewWithIcon:(UIImage *)image
                       title:(NSString *)title
                    subtitle:(NSString *)subtitle
                        tips:(NSString *)tips;
+ (instancetype)viewWithIcon:(UIImage *)image
                       title:(NSString *)title
                  titleColor:(UIColor *)titleColor
               titleFontSize:(NSNumber *)titleFontSize
                    subtitle:(NSString *)subtitle
               subtitleColor:(UIColor *)subtitleColor
               subtitleFontSize:(NSNumber *)subtitleFontSize
                        tips:(NSString *)tips;

+ (void)registerTo:(UIScrollView *)list;

+ (id)cellForList:(id)list atIndexPath:(NSIndexPath *)indexPath;

@end
