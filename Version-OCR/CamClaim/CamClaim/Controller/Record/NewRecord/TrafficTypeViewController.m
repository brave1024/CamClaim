//
//  TrafficTypeViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "TrafficTypeViewController.h"
#import "CCLocationManager.h"
#import "MapViewController.h"

@interface TrafficTypeViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayList;

@property (nonatomic, strong) IBOutlet UIView *viewTableHeader;
@property (nonatomic, strong) IBOutlet MKMapView *mapview;

@property (nonatomic, strong) IBOutlet UIView *viewDate;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;

@property (nonatomic, strong) IBOutlet UIView *viewLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblStart;
@property (nonatomic, strong) IBOutlet UILabel *lblEnd;
@property (nonatomic, strong) IBOutlet UIButton *btnStart;
@property (nonatomic, strong) IBOutlet UIButton *btnEnd;
@property (nonatomic, strong) IBOutlet UIButton *btnTraffic;
@property (nonatomic, strong) IBOutlet UILabel *lblTraffic;

@property (nonatomic, strong) IBOutlet UIImageView *imgviewClaim;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldCost;

@property (nonatomic, strong) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;

// 半透明遮罩
@property (nonatomic, strong) UIView *viewTranslucence;

//
@property (nonatomic, strong) IBOutlet UIView *viewPicker;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnCancel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnDone;

@property typeTraffic typeFlag;
@property (nonatomic, strong) NSDate *date;

// 当前界面自动获取到的位置
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, copy) NSString *currentAddress;
@property BOOL hasGetCurrent;

@property (nonatomic, assign) CLLocationCoordinate2D startLoc;
@property (nonatomic, copy) NSString *startAddress;
@property BOOL hasGetStart;
@property (nonatomic, assign) CLLocationCoordinate2D endLoc;
@property (nonatomic, copy) NSString *endAddress;
@property BOOL hasGetEnd;

- (IBAction)getUserLocation:(id)sender;
- (IBAction)selectTrafficType;
- (IBAction)saveAction;
- (IBAction)submitAction;
- (IBAction)uploadClaimImage;
- (IBAction)showPopViewForDate;

@end

@implementation TrafficTypeViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"交通";
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    [self initView];
    
    [self initPopViewForDate];
    
    [self initViewWithAutoLayout];
    
    [self initData];

    [self settingLanguage];
    
    [self getCurrentLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.mapview.showsUserLocation = YES;
//    self.mapview.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.mapview.showsUserLocation = NO;
//    self.mapview.delegate = nil;
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHeader;
    
    self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);   // 460
    
    self.txtfieldCost.returnKeyType = UIReturnKeyNext;

    self.mapview.delegate = self;
    self.mapview.zoomEnabled = YES;
    self.mapview.scrollEnabled = YES;
    self.mapview.showsUserLocation = YES;
    self.mapview.mapType = MKMapTypeStandard;
    
    self.viewDate.backgroundColor = [UIColor whiteColor];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.viewDate.frame)-0.5, kScreenWidth, 0.5)];
    viewLine.backgroundColor = [UIColor colorWithRed:(CGFloat)208/255 green:(CGFloat)207/255 blue:(CGFloat)208/255 alpha:1];
    [self.viewDate addSubview:viewLine];
    
    self.viewLocation.backgroundColor = [UIColor whiteColor];
    self.viewLocation.layer.borderColor = [UIColor colorWithRed:(CGFloat)208/255 green:(CGFloat)207/255 blue:(CGFloat)208/255 alpha:1].CGColor;
    self.viewLocation.layer.borderWidth = 0.5;
    
    self.lblStart.hidden = NO;
    self.lblEnd.hidden = NO;
    
    [self.btnStart setTitle:nil forState:UIControlStateNormal];
    [self.btnStart setTitleColor:[UIColor colorWithRed:(CGFloat)74/255 green:(CGFloat)163/255 blue:(CGFloat)0.0 alpha:1] forState:UIControlStateNormal];
    [self.btnStart setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    [self.btnEnd setTitle:nil forState:UIControlStateNormal];
    [self.btnEnd setTitleColor:[UIColor colorWithRed:(CGFloat)246/255 green:(CGFloat)81/255 blue:(CGFloat)0.0 alpha:1] forState:UIControlStateNormal];
    [self.btnEnd setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    UIImage *img = [UIImage imageNamed:@"btn_save"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [self.btnSave setBackgroundImage:img forState:UIControlStateNormal];
    
    UIImage *img_ = [UIImage imageNamed:@"btn_resubmit"];
    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [self.btnSubmit setBackgroundImage:img_ forState:UIControlStateNormal];
}

- (void)initPopViewForDate
{
    // 初始化日期选择视图
    self.viewTranslucence = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    self.viewTranslucence.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopViewForDate)];
    [self.viewTranslucence addGestureRecognizer:tapGesture];
    
    CGRect myRect = self.viewPicker.bounds;
    myRect.origin.x = 0;
    myRect.origin.y = CGRectGetHeight(self.viewTranslucence.frame) - myRect.size.height;
    self.viewPicker.frame = CGRectMake(myRect.origin.x, myRect.origin.y, kScreenWidth, myRect.size.height);
    [self.viewTranslucence addSubview:self.viewPicker];
    
    // 默认显示今天
    self.datePicker.date = [NSDate date];
    //[self.datePicker setMinimumDate:minDate];
    [self.datePicker setMaximumDate:[NSDate date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    //[formatter setDateFormat:@"YYYY.MM.dd"];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    self.lblDate.text = [formatter stringFromDate:[NSDate date]];
}

- (void)initData
{
    self.lblTraffic.text = locatizedString(@"traffic_car");
    [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_car"] forState:UIControlStateNormal];
    self.typeFlag = typeTrafficCar;
    
    self.imgviewClaim.image = [UIImage imageNamed:@"img_avatar"];
    
    self.date = [NSDate date];
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


#pragma mark - Data

- (NSMutableArray *)arrayList
{
    if (_arrayList == nil)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"RecordType" ofType:@"plist"];
        _arrayList = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    
    return _arrayList;
}


#pragma mark - BtnTouchAction

- (IBAction)getUserLocation:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    if (tag == kTag)
    {
        // 起始位置
        MapViewController *mapVC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
        mapVC.startFlag = YES;
        mapVC.beforeVC = self;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
    else
    {
        // 终点位置
        MapViewController *mapVC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
        mapVC.startFlag = NO;
        mapVC.beforeVC = self;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

- (IBAction)selectTrafficType
{
    NSString *strTitle = locatizedString(@"traffic_Title");
    NSString *strCancel = locatizedString(@"cancel");
    
    NSString *strCar = locatizedString(@"traffic_car");
    NSString *strTrain = locatizedString(@"traffic_train");
    NSString *strFlight = locatizedString(@"traffic_flight");
    NSString *strShip = locatizedString(@"traffic_ship");
    NSString *strMetro = locatizedString(@"traffic_metro");
    
    //UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择交通方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"汽车", @"火车", @"飞机", @"轮船", @"地铁", nil];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:strTitle
                                                             delegate:self
                                                    cancelButtonTitle:strCancel
                                               destructiveButtonTitle:nil otherButtonTitles:strCar, strTrain, strFlight, strShip, strMetro, nil];
    actionSheet.tag = kTag;
    [actionSheet showInView:self.view];
}

// 保存
- (IBAction)saveAction
{
    
    
}

// 提交
- (IBAction)submitAction
{
    
    
}

// 上传发票
- (IBAction)uploadClaimImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传发票"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"相册", nil];
    actionSheet.tag = kTag + 1;
    [actionSheet showInView:self.view.window];
}

- (IBAction)showPopViewForDate
{
    [self.view addSubview:self.viewTranslucence];
}

- (IBAction)cancelPopViewForTime
{
    [self.viewTranslucence removeFromSuperview];
}

- (IBAction)donePopViewForTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSString *strDate = [formatter stringFromDate:self.datePicker.date];
    self.lblDate.text = strDate;
    self.date = self.datePicker.date;
    
    [self.viewTranslucence removeFromSuperview];
}


#pragma mark - Custom

- (void)hidePopViewForDate
{
    [self.viewTranslucence removeFromSuperview];
    
}

- (void)getStartLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address
{
    self.startLoc = location;
    self.startAddress = address;
    self.hasGetStart = YES;
    
    self.lblStart.hidden = YES;
    
    NSString *strStart = [NSString stringWithFormat:@"[起点] %@", address];
    [self.btnStart setTitle:strStart forState:UIControlStateNormal];
}

- (void)getEndLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address
{
    self.endLoc = location;
    self.endAddress = address;
    self.hasGetEnd = YES;
    
    self.lblEnd.hidden = YES;
    
    NSString *strEnd = [NSString stringWithFormat:@"[终点] %@", address];
    [self.btnEnd setTitle:strEnd forState:UIControlStateNormal];
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


#pragma mark - HttpRequest

// 上传发票请求
- (void)requestForUploadClaimImage:(UIImage *)img
{
    
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.arrayList.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellID = @"cellType";
//    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil)
//    {
//        cell = [SettingCell cellFromNib];
//    }
//    
//    NSDictionary *dic = self.arrayList[indexPath.row];
//    [cell configWithData:dic];
//    
//    cell.lblContent.hidden = YES;
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//    return cell;
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
    
}


#pragma mark - GetLocation

// 当前位置
- (void)getCurrentLocation
{
    NSLog(@"获取当前位置");
    
    __WEAKSELF
    
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        //
        NSLog(@"获取当前位置成功");
        NSLog(@"latitude:%f, longitude:%f", locationCorrrdinate.latitude, locationCorrrdinate.longitude);
        
        // 获取当前地理位置信息<地址>
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks,NSError *error) {
            
            if (placemarks.count > 0)
            {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                NSString *_lastCity = [NSString stringWithFormat:@"%@%@", (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @"")];
                NSLog(@"城市：%@", _lastCity);
                
                NSString *_lastAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@", (placemark.country != nil ? placemark.country : @""), (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @""), (placemark.subLocality != nil ? placemark.subLocality : @""), (placemark.thoroughfare != nil ? placemark.thoroughfare : @""), (placemark.subThoroughfare != nil ? placemark.subThoroughfare : @"")];   // 详细地址
                NSLog(@"地址：%@", _lastAddress);
                
                // 保存当前用户经纬度
                wself.currentLocation = CLLocationCoordinate2DMake(locationCorrrdinate.latitude, locationCorrrdinate.longitude);
                //wself.currentAddress = _lastAddress;
                wself.currentAddress = [self getFinalAddress:placemark];
                
                if (wself.hasGetStart == NO)
                {
                    NSLog(@"...[getCurrentLocation]...用户未手动选点，则默认先显示自动获取的");
                    
                    NSString *strStart = [NSString stringWithFormat:@"[起点] %@", wself.currentAddress];
                    [wself.btnStart setTitle:strStart forState:UIControlStateNormal];
                    
                    wself.lblStart.hidden = YES;
                }
                else
                {
                    NSLog(@"用户已手动选点，则不再显示自动获取的");
                }
            }
            
        }];
        
        // 已获取到当前位置...~!@
        self.currentLocation = CLLocationCoordinate2DMake(locationCorrrdinate.latitude, locationCorrrdinate.longitude);;
        self.hasGetCurrent = YES;
        
//        // 经纬度<初始化的坐标>
//        CLLocationCoordinate2D coor2d = {locationCorrrdinate.latitude, locationCorrrdinate.longitude};
//        // 显示范围<数值越大,范围就越大>
//        MKCoordinateSpan span = {0.06, 0.06};
//        MKCoordinateRegion region = {coor2d, span};
//        [self.mapview setRegion:region animated:YES];
        
        if (wself.mapview != nil && wself.mapview.delegate != nil)
        {
            //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locationCorrrdinate, 0.06, 0.06);
            
            //设置显示范围
            MKCoordinateRegion region;
            region.span.latitudeDelta = 0.001;
            region.span.longitudeDelta = 0.001;
            region.center = locationCorrrdinate;
            // 设置显示位置(动画)
            [wself.mapview setRegion:region animated:YES];
            // 设置地图显示的类型及根据范围进行显示
            [wself.mapview regionThatFits:region];
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


//#pragma mark - CLLocationManagerDelegate
//
//// Deprecated:Use locationManager:didUpdateLocations: instead.
////- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
////{
////    NSLog(@"latitude:%@", [NSString stringWithFormat:@"%.3f", newLocation.coordinate.latitude]);
////    NSLog(@"longitude:%@", [NSString stringWithFormat:@"%.3f", newLocation.coordinate.longitude]);
////}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    if (locations != nil && locations.count > 0)
//    {
//        CLLocation *newLocation = locations[0];
//        NSLog(@"latitude:%@", [NSString stringWithFormat:@"%.3f", newLocation.coordinate.latitude]);
//        NSLog(@"longitude:%@", [NSString stringWithFormat:@"%.3f", newLocation.coordinate.longitude]);
//        
//        if (self.mapview != nil && self.mapview.delegate != nil)
//        {
//            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
//            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
//            [self.mapview setRegion:region animated:YES];
//        }
//    }
//    else
//    {
//        NSLog(@"获取当前位置失败");
//    }
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"获取当前位置失败:%@", error);
//}


#pragma mark - MKMapViewDelegate

// MapView委托方法，当定位自身时调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    __WEAKSELF
    
    // 获取当前地理位置信息<地址>
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks,NSError *error) {
        
        if (placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *_lastCity = [NSString stringWithFormat:@"%@%@", (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @"")];
            NSLog(@"城市：%@", _lastCity);
            
            NSString *_lastAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@", (placemark.country != nil ? placemark.country : @""), (placemark.administrativeArea != nil ? placemark.administrativeArea : @""), (placemark.locality != nil ? placemark.locality : @""), (placemark.subLocality != nil ? placemark.subLocality : @""), (placemark.thoroughfare != nil ? placemark.thoroughfare : @""), (placemark.subThoroughfare != nil ? placemark.subThoroughfare : @"")];   // 详细地址
            NSLog(@"地址：%@", _lastAddress);
            
            wself.currentLocation = userLocation.coordinate;
            //wself.currentAddress = _lastAddress;
            wself.currentAddress = [self getFinalAddress:placemark];
            
            if (wself.hasGetStart == NO)
            {
                NSLog(@"[MKMapView]...>>>用户未手动选点，则默认先显示自动获取的");
                
                NSString *strStart = [NSString stringWithFormat:@"[起点] %@", wself.currentAddress];
                [wself.btnStart setTitle:strStart forState:UIControlStateNormal];
                
                wself.lblStart.hidden = YES;
            }
            else
            {
                NSLog(@"用户已手动选点，则不再显示自动获取的");
            }
        }
        
    }];
    
    CLLocationCoordinate2D loc = [userLocation coordinate];
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 0.06, 0.06);
    
    // 已获取到当前位置...~!@
    self.currentLocation = loc;
    self.hasGetCurrent = YES;
    
    if (self.mapview != nil && self.mapview.delegate != nil)
    {
        //设置显示范围
        MKCoordinateRegion region;
        region.span.latitudeDelta = 0.001;
        region.span.longitudeDelta = 0.001;
        region.center = loc;
        
        //[self.mapview setRegion:region animated:YES];
        
        // 设置显示位置(动画)
        [self.mapview setRegion:region animated:YES];
        // 设置地图显示的类型及根据范围进行显示
        [self.mapview regionThatFits:region];
    }
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"mapViewWillStartLoadingMap");
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"mapViewDidFinishLoadingMap");
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"mapViewDidFailLoadingMap:%@", [error description]);
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kTag)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"car");
            //self.lblTraffic.text = @"Car";
            self.lblTraffic.text = locatizedString(@"traffic_car");
            [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_car"] forState:UIControlStateNormal];
            self.typeFlag = typeTrafficCar;
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"train");
            //self.lblTraffic.text = @"Train";
            self.lblTraffic.text = locatizedString(@"traffic_train");
            [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_train"] forState:UIControlStateNormal];
            self.typeFlag = typeTrafficTrain;
        }
        else if (buttonIndex == 2)
        {
            NSLog(@"flight");
            //self.lblTraffic.text = @"Flight";
            self.lblTraffic.text = locatizedString(@"traffic_flight");
            [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_flight"] forState:UIControlStateNormal];
            self.typeFlag = typeTrafficFlight;
        }
        else if (buttonIndex == 3)
        {
            NSLog(@"ship");
            //self.lblTraffic.text = @"Ship";
            self.lblTraffic.text = locatizedString(@"traffic_ship");
            [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_ship"] forState:UIControlStateNormal];
            self.typeFlag = typeTrafficShip;
        }
        else if (buttonIndex == 4)
        {
            NSLog(@"metro");
            //self.lblTraffic.text = @"Metro";
            self.lblTraffic.text = locatizedString(@"traffic_metro");
            [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_metro"] forState:UIControlStateNormal];
            self.typeFlag = typeTrafficMetro;
        }
        else if (buttonIndex == 5)
        {
            NSLog(@"cancel");
        }
    }
    else if (actionSheet.tag == kTag + 1)
    {
        UIImagePickerControllerSourceType aSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        switch (buttonIndex)
        {
            case 0:
                LogTrace( @"相机");
                aSourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                aSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                LogTrace( @"从相册获取图片");
                break;
                
            default:
                return;
        }
        
        [self pickerImageWithType:aSourceType];
    }
}

- (void)pickerImageWithType:(UIImagePickerControllerSourceType)aSourceType
{
    if (aSourceType == UIImagePickerControllerSourceTypeCamera &&
        ![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        aSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
//    sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
//    sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
//    sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    if(aSourceType == UIImagePickerControllerSourceTypePhotoLibrary &&
       [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        picker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
    }
    
    [picker setDelegate:self];
    [picker setAllowsEditing:NO];  //设置可编辑
    [picker setSourceType:aSourceType];
    [self presentViewController:picker animated:YES completion:nil];   //进入照相界面
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgPicker = nil;
    imgPicker = [info objectForKey:UIImagePickerControllerEditedImage];
    if (imgPicker == nil)
    {
        imgPicker = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
            self.imgviewClaim.image = imgPicker;
            
            // 上传发票
            [self requestForUploadClaimImage:imgPicker];
        });
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    LogTrace(@"Picker Image Cancel!");
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 只可输入数字和小数点
    
    
    return YES;
}


@end
