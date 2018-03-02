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

#import "AddressTableViewCell.h"
#import "AddressAreaItem.h"
@interface AddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel * addressLabel;
@end
@implementation AddressTableViewCell

- (void)setModel:(id)model
{
    _model = model;
    if ([_model isKindOfClass:[ProvinceItem class]])
    {
        ProvinceItem * provinceItem = _model;
        _addressLabel.text = provinceItem.name;
        _addressLabel.textColor = provinceItem.isSelected ? [UIColor orangeColor] : [UIColor blackColor] ;
    }
    else if ([_model isKindOfClass:[CityItem class]])
    {
        CityItem * cityItem = _model;
        _addressLabel.text = cityItem.name;
        _addressLabel.textColor = cityItem.isSelected ? [UIColor orangeColor] : [UIColor blackColor] ;
    }
    else
    {
        AreaItem * areaItem = _model;
        _addressLabel.text = areaItem.name;
        _addressLabel.textColor = areaItem.isSelected ? [UIColor orangeColor] : [UIColor blackColor] ;
    }
}

@end
