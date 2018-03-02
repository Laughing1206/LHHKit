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

@class AddressItem;
@class AreaItem;
@class CityItem;
@class ProvinceItem;

#pragma mark - Protocols
@protocol AddressItem <NSObject> @end
@protocol AreaItem <NSObject> @end
@protocol CityItem <NSObject> @end
@protocol ProvinceItem <NSObject> @end

@interface AddressItem : NSObject
@property (nonatomic, copy) NSString * cityID;
@property (nonatomic, copy) NSString * parentcityID;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * name;
@property (nonatomic,assign) BOOL  isSelected;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

@interface AreaItem : AddressItem
@end
@interface CityItem : AddressItem
@property (nonatomic, strong) NSArray<AreaItem *> * areas;
@end
@interface ProvinceItem : AddressItem
@property (nonatomic, strong) NSArray<CityItem *> * cities;
@end
