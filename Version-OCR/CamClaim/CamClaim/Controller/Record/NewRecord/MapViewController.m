//
//  MapViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "CCLocationManager.h"
#import "CCPoint.h"

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapview;

@property (nonatomic, strong) NSMutableArray *arrayPoints;

@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, copy) NSString *currentAddress;
@property BOOL hasGetCurrent;       //

@property BOOL hasSelectedByUser;   //
@property BOOL hasGetLocation;      // 已经定位到当前位置

@end

@implementation MapViewController

//#ifdef DEBUG
//- (BOOL)respondsToSelector:(SEL)aSelector
//{
//    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
//    return [super respondsToSelector:aSelector];
//}
//#endif

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"地图选点";
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    // 确定
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:@"Done" forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self initData];
    
    [self settingLanguage];
    
    [self getCurrentLocation];
}

- (void)initView
{
    self.mapview.delegate = self;
    self.mapview.zoomEnabled = YES;
    self.mapview.scrollEnabled = YES;
    self.mapview.showsUserLocation = YES;
    self.mapview.mapType = MKMapTypeStandard;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.5;
    longPress.allowableMovement = 10.0;
    [self.mapview addGestureRecognizer:longPress];
}

- (void)initData
{
    self.hasGetCurrent = NO;
    self.currentLocation = CLLocationCoordinate2DMake(0.0, 0.0);
    self.currentAddress = nil;
    
    self.hasSelectedByUser = NO;
    self.hasGetLocation = NO;
}

- (NSMutableArray *)arrayPoints
{
    if (_arrayPoints == nil)
    {
        _arrayPoints = [[NSMutableArray alloc] init];
    }
    return _arrayPoints;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - NavViewDelegate

// 查看or隐藏菜单栏
- (void)backAction
{
    self.mapview.showsUserLocation = NO;
    self.mapview.delegate = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 保存
- (void)moreAction
{
    // 保存已选坐标
    if (self.hasGetCurrent == NO)
    {
        [self toast:@"请长按选取位置"];
        return;
    }
    
    if (self.startFlag == YES)
    {
        // 起点
        
        //[self.trafficVC getStartLocation:self.currentLocation andAddress:self.currentAddress];
        
        if (self.indexVC == 0)
        {
            TrafficTypeViewController *trafficVC = (TrafficTypeViewController *)self.beforeVC;
            [trafficVC getStartLocation:self.currentLocation andAddress:self.currentAddress];
        }
        else if (self.indexVC == 1)
        {
            FoodTypeViewController *foodVC = (FoodTypeViewController *)self.beforeVC;
            [foodVC getStartLocation:self.currentLocation andAddress:self.currentAddress];
        }
        else if (self.indexVC == 2)
        {
            HotelTypeViewController *hotelVC = (HotelTypeViewController *)self.beforeVC;
            [hotelVC getStartLocation:self.currentLocation andAddress:self.currentAddress];
        }
        else if (self.indexVC == 3)
        {
            OtherTypeViewController *otherVC = (OtherTypeViewController *)self.beforeVC;
            [otherVC getStartLocation:self.currentLocation andAddress:self.currentAddress];
        }
    }
    else
    {
        // 终点
        
        TrafficTypeViewController *trafficVC = (TrafficTypeViewController *)self.beforeVC;
        [trafficVC getEndLocation:self.currentLocation andAddress:self.currentAddress];
    }
    
    self.mapview.showsUserLocation = NO;
    self.mapview.delegate = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - AutoLayout

- (void)initViewWithAutoLayout
{
    //
    
    if (kScreenWidth == kWidthFor5)
    {
        
    }
    else if (kScreenWidth == kWidthFor6)
    {
        
    }
    else if (kScreenWidth == kWidthFor6plus)
    {
        
    }
}


#pragma mark - Language

- (void)settingLanguage
{
    
    
}


#pragma mark - Custom

- (void)longPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        return;
    }
    
    [self.mapview removeAnnotations:self.arrayPoints];
    [self.arrayPoints removeAllObjects];
    
    NSString *title = nil;
    if (self.startFlag == YES)
    {
        title = @"已选位置 [起点]";
    }
    else
    {
        title = @"已选位置 [终点]";
    }
    
    // 坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapview];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapview convertPoint:touchPoint toCoordinateFromView:self.mapview];
    
    __block MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = touchMapCoordinate;
    pointAnnotation.title = title;
    pointAnnotation.subtitle = nil;
    //pointAnnotation.subtitle = @"中国湖北省武汉市洪山区卓刀泉南路119号";
    
    [self.arrayPoints addObject:pointAnnotation];
    [self.mapview addAnnotations:self.arrayPoints];
    
    __WEAKSELF
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error) {
        
        if (placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            NSString *_lastCity = [NSString stringWithFormat:@"%@%@", (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @"")];
            NSLog(@"城市：%@", _lastCity);
            
            NSString *_lastAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@", (placemark.country != nil ? placemark.country : @""), (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @""), (placemark.subLocality != nil ? placemark.subLocality : @""), (placemark.thoroughfare != nil ? placemark.thoroughfare : @""), (placemark.subThoroughfare != nil ? placemark.subThoroughfare : @"")];   // 详细地址
            NSLog(@"地址：%@", _lastAddress);
            
            //pointAnnotation.subtitle = _lastAddress;
            
            NSString *strAddress = [self getFinalAddress:placemark];
            pointAnnotation.subtitle = strAddress;
            
            wself.currentLocation = touchMapCoordinate;
            wself.currentAddress = strAddress;
            wself.hasGetCurrent = YES;
            
            wself.hasSelectedByUser = YES;
        }
        
    }];
}

- (NSString *)getFinalAddress:(CLPlacemark *)place
{
    NSString *country = (place.country != nil ? place.country : @"");
    NSString *area = (place.administrativeArea != nil ? place.administrativeArea : @"");
    NSString *city = (place.locality != nil ? place.locality : @"");
    NSString *subCity = (place.subLocality != nil ? place.subLocality : @"");
    NSString *district = (place.thoroughfare != nil ? place.thoroughfare : @"");
    NSString *streat = (place.subThoroughfare != nil ? place.subThoroughfare : @"");
    
    NSLog(@"country:%@", country);
    NSLog(@"area:%@", area);
    NSLog(@"city:%@", city);
    NSLog(@"subCity:%@", subCity);
    NSLog(@"district:%@", district);
    NSLog(@"streat:%@", streat);
    
//    2015-10-06 19:47:08.225 CamClaimPro[11509:3830766] 城市：湖北省武汉市
//    2015-10-06 19:47:08.225 CamClaimPro[11509:3830766] 地址：中国湖北省武汉市洪山区康福路1号
//    2015-10-06 19:47:08.225 CamClaimPro[11509:3830766] country:中国
//    2015-10-06 19:47:08.225 CamClaimPro[11509:3830766] area:湖北省
//    2015-10-06 19:47:08.225 CamClaimPro[11509:3830766] city:武汉市
//    2015-10-06 19:47:08.226 CamClaimPro[11509:3830766] subCity:洪山区
//    2015-10-06 19:47:08.226 CamClaimPro[11509:3830766] district:康福路
//    2015-10-06 19:47:08.226 CamClaimPro[11509:3830766] streat:1号
    
    if ([area isEqualToString:country] == YES)
    {
        area = @"";
    }
    
    if ([city isEqualToString:country] == YES)
    {
        city = @"";
    }
    
    if ([subCity isEqualToString:country] == YES)
    {
        subCity = @"";
    }
    
    if ([district isEqualToString:country] == YES)
    {
        district = @"";
    }
    
    /**********************************************/
    
    if ([city isEqualToString:area] == YES)
    {
        city = @"";
    }
    
    if ([subCity isEqualToString:area] == YES)
    {
        subCity = @"";
    }
    
    if ([district isEqualToString:area] == YES)
    {
        district = @"";
    }
    
    /**********************************************/
    
    if ([subCity isEqualToString:city] == YES)
    {
        subCity = @"";
    }
    
    if ([district isEqualToString:city] == YES)
    {
        district = @"";
    }
    
    /**********************************************/
    
    if ([district isEqualToString:subCity] == YES)
    {
        district = @"";
    }
    
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@%@", country, area, city, subCity, district, streat];
    return address;
}


#pragma mark - MKMapViewDelegate

// MapView委托方法，当定位自身时调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.hasGetLocation == YES)
    {
        NSLog(@"[MKMapView]...定位当前位置的操作只执行一次,之前已定位成功,故当前不再进行相关操作");
        return;
    }
    
    NSLog(@"[MKMapView]...自动定位当前位置");
    self.hasGetLocation = YES;
    
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 0.06, 0.06);
    [self.mapview setRegion:region animated:YES];
}

// mapView:viewForAnnotation: provides the view for each annotation.
// This method may be called for all or some of the added annotations.
// For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *defaultPinID = @"com.camclaim.pin";
    __block MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (pinView == nil)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    
    self.mapview.userLocation.title = @"当前位置";
    self.mapview.userLocation.subtitle = nil;
    
    __WEAKSELF
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *newLocation = self.mapview.userLocation.location;
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error) {
        
        if (placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *_lastCity = [NSString stringWithFormat:@"%@%@", (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @"")];
            NSLog(@"城市：%@", _lastCity);
            
            NSString *_lastAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@", (placemark.country != nil ? placemark.country : @""), (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @""), (placemark.subLocality != nil ? placemark.subLocality : @""), (placemark.thoroughfare != nil ? placemark.thoroughfare : @""), (placemark.subThoroughfare != nil ? placemark.subThoroughfare : @"")];   // 详细地址
            NSLog(@"地址：%@", _lastAddress);
            
            //wself.mapview.userLocation.subtitle = _lastAddress;
            
            NSString *strAddress = [self getFinalAddress:placemark];
            wself.mapview.userLocation.subtitle = strAddress;
            
            if (wself.hasSelectedByUser == NO)
            {
                wself.currentLocation = newLocation.coordinate;
                wself.currentAddress = strAddress;
                wself.hasGetCurrent = YES;
            }
            else
            {
                NSLog(@"用户已手动选点...");
            }
        }
        
    }];
    
    return pinView;
}

// mapView:didAddAnnotationViews: is called after the annotation views have been added and positioned in the map.
// The delegate can implement this method to animate the adding of the annotations views.
// Use the current positions of the annotation views as the destinations of the animation.
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //
}


//#pragma mark - Touch Event
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *getTouch = [touches anyObject];
//    // 屏幕上当前点击位置的坐标
//    CGPoint touchPoint = [getTouch locationInView:self.mapview];
//    // 将屏幕上的点转换成地图上的点
//    CLLocationCoordinate2D  location = [self.mapview convertPoint:touchPoint
//                                             toCoordinateFromView:self.mapview];
//    //
//    NSString *str = [NSString stringWithFormat:@"latitude = %f, longitude = %f", location.latitude, location.longitude];
//    NSLog(@"%@", str);
//    
//    [self.mapview removeAnnotations:self.arrayPoints];
//    [self.arrayPoints removeAllObjects];
//    
//    // 自定义注释（起始点）
//    CCPoint *point = [[CCPoint alloc] initWithCoordinate:location andTitle:@"Cam Claim" subTitle:@"Cam Claim APP"];
//    //point.title = @"Cam Claim";
//    //point.subTitle = @"Cam Claim APP";
//    
//    [self.arrayPoints addObject:point];
//    [self.mapview addAnnotations:self.arrayPoints];
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error) {
//        
//        if (placemarks.count > 0)
//        {
//            CLPlacemark *placemark = [placemarks objectAtIndex:0];
//            NSString *_lastCity = [NSString stringWithFormat:@"%@%@", (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @"")];
//            NSLog(@"城市：%@", _lastCity);
//            
//            NSString *_lastAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@", (placemark.country != nil ? placemark.country : @""), (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @""), (placemark.subLocality != nil ? placemark.subLocality : @""), (placemark.thoroughfare != nil ? placemark.thoroughfare : @""), (placemark.subThoroughfare != nil ? placemark.subThoroughfare : @"")];   // 详细地址
//            NSLog(@"地址：%@", _lastAddress);
//        }
//        
//    }];
//}


#pragma mark - GetLocation

// 当前位置
- (void)getCurrentLocation
{
    NSLog(@"获取当前位置");
    
    __WEAKSELF
    
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        //
        NSLog(@"...[getCurrentLocation]...获取当前位置成功");
        NSLog(@"latitude:%f, longitude:%f", locationCorrrdinate.latitude, locationCorrrdinate.longitude);
        
        if (wself.mapview != nil && wself.mapview.delegate != nil)
        {
//            if (self.hasGetLocation == YES)
//            {
//                // 只定位当前位置一次
//                return;
//            }
//            
//            self.hasGetLocation = YES;
//            
//            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locationCorrrdinate, 0.06, 0.06);
//            [wself.mapview setRegion:region animated:YES];
            
            wself.mapview.userLocation.title = @"当前位置";
            wself.mapview.userLocation.subtitle = nil;
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            CLLocation *newLocation = self.mapview.userLocation.location;
            [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error) {
                
                if (placemarks.count > 0)
                {
                    CLPlacemark *placemark = [placemarks objectAtIndex:0];
                    NSString *_lastCity = [NSString stringWithFormat:@"%@%@", (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @"")];
                    NSLog(@"城市：%@", _lastCity);
                    
                    NSString *_lastAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@", (placemark.country != nil ? placemark.country : @""), (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @""), (placemark.subLocality != nil ? placemark.subLocality : @""), (placemark.thoroughfare != nil ? placemark.thoroughfare : @""), (placemark.subThoroughfare != nil ? placemark.subThoroughfare : @"")];   // 详细地址
                    NSLog(@"地址：%@", _lastAddress);
                    
                    //wself.mapview.userLocation.subtitle = _lastAddress;
                    
                    NSString *strAddress = [self getFinalAddress:placemark];
                    wself.mapview.userLocation.subtitle = strAddress;
                    
                    if (wself.hasSelectedByUser == NO)
                    {
                        wself.currentLocation = locationCorrrdinate;
                        wself.currentAddress = strAddress;
                        wself.hasGetCurrent = YES;
                    }
                }
                
            }];
        }
        
    } withError:^(NSError *error) {
        
        NSLog(@"获取当前位置失败:%@", error);
        [wself toast:@"无法定位当前位置"];
        
        // 定位香港
        // latitude = 22.332999, longitude = 114.144513
        // 城市：香港特別行政區香港特別行政區
        // 地址：中國香港特別行政區香港特別行政區深水埗區百老匯街31A號
        
        // 经纬度<初始化的坐标>
        CLLocationCoordinate2D coor2d = {22.332999, 114.144513};
        // 显示范围<数值越大,范围就越大>
        MKCoordinateSpan span = {0.06, 0.06};
        MKCoordinateRegion region = {coor2d, span};
        [wself.mapview setRegion:region animated:YES];
        [wself.mapview regionThatFits:region];
        
    }];
}


@end
