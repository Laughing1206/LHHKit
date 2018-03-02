//
//  CityTool.m
//  ChooseLocation
//
//  Created by 李欢欢 on 2017/11/7.
//  Copyright © 2017年 HY. All rights reserved.
//

#import "CityTool.h"

@implementation CityTool

+ (NSArray<ProvinceItem *> *)getProvinces;
{
    NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"Cities" ofType:@"json"];
    NSError * error;
    NSArray * jsonObjectArray =[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath]
                                                               options:kNilOptions
                                                                 error:&error];
    
    NSMutableArray * dataArray = [NSMutableArray array];
    [dataArray removeAllObjects];
    for (NSDictionary * dictionary in jsonObjectArray)
    {
        AddressItem * item = [[AddressItem alloc] initWithDict:dictionary];
        [dataArray addObject:item];
    }
    
    NSMutableArray * provinceArray = [NSMutableArray array];
    NSMutableArray * addressArray = [NSMutableArray array];
    [provinceArray removeAllObjects];
    [addressArray removeAllObjects];
    
    for (AddressItem * address in dataArray)
    {
        if ([address.parentcityID isEqualToString:@"0"])
        {
            ProvinceItem * provinceItem = [[ProvinceItem alloc]init];
            provinceItem.cityID = address.cityID;
            provinceItem.parentcityID = address.parentcityID;
            provinceItem.code = address.code;
            provinceItem.name = address.name;
            [provinceArray addObject:provinceItem];
        }
        else
        {
            [addressArray addObject:address];
        }
    }
    
    for (ProvinceItem * province in provinceArray)
    {
        NSMutableArray * cities = [NSMutableArray array];
        [cities removeAllObjects];
        
        for (AddressItem * address in addressArray)
        {
            if ([address.parentcityID isEqualToString:province.cityID])
            {
                CityItem * cityItem = [[CityItem alloc]init];
                cityItem.cityID = address.cityID;
                cityItem.parentcityID = address.parentcityID;
                cityItem.code = address.code;
                cityItem.name = address.name;
                [cities addObject:cityItem];
            }
        }
        
        province.cities = cities;
        
        for (CityItem * city in province.cities)
        {
            NSMutableArray * areas = [NSMutableArray array];
            [areas removeAllObjects];
            
            for (AddressItem * address in addressArray)
            {
                if ([address.parentcityID isEqualToString:city.cityID])
                {
                    AreaItem * areaItem = [[AreaItem alloc]init];
                    areaItem.cityID = address.cityID;
                    areaItem.parentcityID = address.parentcityID;
                    areaItem.code = address.code;
                    areaItem.name = address.name;
                    [areas addObject:address];
                }
            }
            
            city.areas = areas;
        }
    }
    
    return provinceArray;
}

@end
