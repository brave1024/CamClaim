//
//  CCLocationManager.m
//  MMLocationManager
//
//  Created by Xia Zhiyong on 15-06-05.
//  Copyright (c) 2015年 Xia Zhiyong. All rights reserved.
//

#import "CCLocationManager.h"

@interface CCLocationManager ()
{
    CLLocationManager *_manager;
}

@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;

@end


@implementation CCLocationManager

+ (CCLocationManager *)shareLocation
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        float longitude = [standard floatForKey:CCLastLongitude];
        float latitude = [standard floatForKey:CCLastLatitude];
        
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:CCLastCity];
        self.lastAddress = [standard objectForKey:CCLastAddress];
    }
    return self;
}

// 获取经纬度
- (void)getLocationCoordinate:(LocationBlock)locaiontBlock withError:(LocationErrorBlock)errorBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.errorBlock = [errorBlock copy];
    
    [self startLocation];
}

// 获取坐标和详细地址
- (void)getLocationCoordinate:(LocationBlock)locaiontBlock withAddress:(NSStringBlock)addressBlock withError:(LocationErrorBlock)errorBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    self.errorBlock = [errorBlock copy];
    
    [self startLocation];
}

// 获取详细地址
- (void)getAddress:(NSStringBlock)addressBlock withError:(LocationErrorBlock)errorBlock
{
    self.addressBlock = [addressBlock copy];
    self.errorBlock = [errorBlock copy];
    
    [self startLocation];
}

// 获取省市
- (void)getCity:(NSStringBlock)cityBlock withError:(LocationErrorBlock)errorBlock
{
    self.cityBlock = [cityBlock copy];
    self.errorBlock = [errorBlock copy];
    
    [self startLocation];
}


#pragma mark - 开始定位

- (void)startLocation
{
    if ([CLLocationManager locationServicesEnabled] == YES && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.distanceFilter = 10;   // 10m
        //[_manager requestAlwaysAuthorization];
        //[_manager requestWhenInUseAuthorization];
        
        // iOS8需要授权
        if (__CUR_IOS_VERSION >= __IPHONE_8_0)
        {
            [_manager requestWhenInUseAuthorization];  // 调用了这句,就会弹出允许框了.
        }
        
        [_manager startUpdatingLocation];
    }
    else
    {
        UIAlertView *alvertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务，请到设置->隐私，打开定位服务，并允许当前应用访问位置信息。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
}

- (void)stopLocation
{
    _manager = nil;
}


#pragma mark CLLocationManagerDelegate

// 获取经纬度成功
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"locationManager didUpdateToLocation");
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error) {
        
         if (placemarks.count > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             _lastCity = [NSString stringWithFormat:@"%@%@", (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @"")];
             [standard setObject:_lastCity forKey:CCLastCity];  // 省市地址
             NSLog(@"______%@", _lastCity);

             _lastAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@", (placemark.country != nil ? placemark.country : @""), (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @""), (placemark.subLocality != nil ? placemark.subLocality : @""), (placemark.thoroughfare != nil ? placemark.thoroughfare : @""), (placemark.subThoroughfare != nil ? placemark.subThoroughfare : @"")];   // 详细地址
             NSLog(@"______%@", _lastAddress);
         }
         
         if (_cityBlock)
         {
             _cityBlock(_lastCity);
             _cityBlock = nil;
         }
        
         if (_addressBlock)
         {
             _addressBlock(_lastAddress);
             _addressBlock = nil;
         }
         
     }];
    
    //NSLog(@"%f--%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [standard setObject:@(newLocation.coordinate.latitude) forKey:CCLastLatitude];
    [standard setObject:@(newLocation.coordinate.longitude) forKey:CCLastLongitude];

    _lastCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    if (_locationBlock)
    {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }
    
    [manager stopUpdatingLocation];
}

// 获取经纬度失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager didFailWithError");
    
    [self stopLocation];
    
    if (_errorBlock)
    {
        _errorBlock(error);
        _errorBlock = nil;
    }
}


@end
