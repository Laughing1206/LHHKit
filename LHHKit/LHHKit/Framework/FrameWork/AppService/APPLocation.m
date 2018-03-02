//
//  APPLocation.m
//  SunnyProject
//
//  Created by 李欢欢 on 2018/1/11.
//  Copyright © 2018年 李欢欢. All rights reserved.
//

#import "APPLocation.h"

@interface APPLocation ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLGeocoder * geocoder;
@end

@implementation APPLocation

SingletonImplemention(APPLocation)

+ (void)load
{
    [AppService addService:[self sharedAPPLocation]];
}

- (void)setupLocation
{
    [self.locationManager startUpdatingLocation];
}
#pragma mark 定位相关

- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [_locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * location = [locations lastObject];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
//        [UserModel sharedUserModel].location = location;
//        
//        for (CLPlacemark * placemark in placemarks)
//        {
//            [UserModel sharedUserModel].locationName = placemark.addressDictionary[@"City"];
//        }
        [self.locationManager stopUpdatingLocation];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:APPLocationDidFinishNotifity object:nil];
        
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            // NSLog(@"用户还未决定授权");
            if (@available(iOS 8.0, *))
            {
                if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)])
                {
                    
                    [manager requestWhenInUseAuthorization];//--这个在xcode6.0之前的版本，会报编译错误。同时kCLAuthorizationStatusNotDetermined
                }
            }
            break;
        }
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled])
            {
                // NSLog(@"定位服务开启，被拒绝");
            }
            else
            {
                // NSLog(@"定位服务关闭，不可用");
            }
//            CLLocation * location = [[CLLocation alloc] initWithLatitude:39.9151365672 longitude:116.4037447556];
//            [UserModel sharedUserModel].location = location;
//            [UserModel sharedUserModel].locationName = @"北京市";
            [self.locationManager stopUpdatingLocation];
            [[NSNotificationCenter defaultCenter] postNotificationName:APPLocationDidFinishNotifity object:nil];
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            // NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            // NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}

@end
