//
//  TrafficDetailViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "TrafficDetailViewController.h"
#import "CCLocationManager.h"
#import "MapViewController.h"
#import "CompanyModel.h"

@interface TrafficDetailViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

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
@property (nonatomic, strong) IBOutlet UITextField *txtfieldCompany;

@property (nonatomic, strong) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;

// 半透明遮罩
@property (nonatomic, strong) UIView *viewTranslucence;
//
@property (nonatomic, strong) IBOutlet UIView *viewPicker;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnCancel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnDone;

// 半透明遮罩
@property (nonatomic, strong) UIView *viewTranslucence_;
//
@property (nonatomic, strong) IBOutlet UIView *viewClaimPicker;
@property (nonatomic, strong) IBOutlet UIPickerView *claimPicker;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnCancel_;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnDone_;

@property (nonatomic, strong) NSMutableArray *arrayUserCompany;
@property NSInteger indexForCompany;
@property BOOL hasRequestForCompany;

@property (nonatomic, weak) IBOutlet UIView *viewStatusBar;
@property (nonatomic, weak) IBOutlet UILabel *lblStatusBar;

@property (nonatomic, strong) IBOutlet UIView *viewStatus;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewStatus;
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;

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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewStatusHeight;

// Language
@property (nonatomic, strong) IBOutlet UILabel *lblPhoto;
@property (nonatomic, strong) IBOutlet UILabel *lblCost;
@property (nonatomic, strong) IBOutlet UILabel *lblCompany;

- (IBAction)getUserLocation:(id)sender;
- (IBAction)selectTrafficType;
- (IBAction)saveAction;
- (IBAction)submitAction;
- (IBAction)uploadClaimImage;
- (IBAction)showPopViewForDate;
- (IBAction)selectCompany;

- (IBAction)cancelPopViewForTime;
- (IBAction)donePopViewForTime;

- (IBAction)cancelPopViewForClaim;
- (IBAction)donePopViewForClaim;

@end


@implementation TrafficDetailViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navView.lblTitle.text = @"交通";
    
    NSString *strValue = locatizedString(@"type_traffic");
    self.navView.lblTitle.text = strValue;
    
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
    self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);   // 460 505
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHeader;
    
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
    self.btnSave.layer.cornerRadius = 6;
    self.btnSave.layer.masksToBounds = YES;
    
    UIImage *img_ = [UIImage imageNamed:@"btn_resubmit"];
    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [self.btnSubmit setBackgroundImage:img_ forState:UIControlStateNormal];
    self.btnSubmit.layer.cornerRadius = 6;
    self.btnSubmit.layer.masksToBounds = YES;
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
    
    self.date = [NSDate date];
    
    /*****************************************************************/
    
    self.viewTranslucence_ = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    self.viewTranslucence_.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer *tapGesture_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopViewForClaim)];
    [self.viewTranslucence_ addGestureRecognizer:tapGesture_];
    
    myRect = self.viewClaimPicker.bounds;
    myRect.origin.x = 0;
    myRect.origin.y = CGRectGetHeight(self.viewTranslucence_.frame) - myRect.size.height;
    self.viewClaimPicker.frame = CGRectMake(myRect.origin.x, myRect.origin.y, kScreenWidth, myRect.size.height);
    [self.viewTranslucence_ addSubview:self.viewClaimPicker];
    
    self.claimPicker.delegate = self;
    self.claimPicker.dataSource = self;
    [self.claimPicker reloadAllComponents];
}

/*
{
    "canmoney": "2168.00",
    "cartype": "飞机",
    "clientcompany": "",
    "days": 0,
    "eatway": "",
    "forusername": "",
    "gmoney": "0",
    "id": 0,
    "imgurl": "",
    "jiyu": "0",
    "location": "",
    "message": null,
    "pfile": null,
    "qaddress": "中国湖北省武汉市江夏区软件园中路12号",
    "qjd": "30.476747",
    "qwd": "114.401590",
    "status": "approving",
    "store": "",
    "typeid": "交通",
    "useinfo": "",
    "usercompany": "酷控科技有限责任公司",
    "userid": 0,
    "usetime": "2015/10",
    "usingname": "",
    "zaddress": "中国北京市东城区朝内大街137号",
    "zjd": "39.926049",
    "zwd": "116.425220"
}
*/

/*
<ClaimItem>
[userid]: 0
[pfile]: <nil>
[location]:
[status]: approving
[forusername]:
[qaddress]: 中国湖北省武汉市江夏区软件园中路12号
[qwd]: 114.401590
[zaddress]: 中国北京市东城区朝内大街137号
[zwd]: 116.425220
[days]: 0
[clientcompany]:
[cartype]: 飞机
[imgurl]: camclaim_20151027123332118
[store]:
[usetime]: 2015/10
[usercompany]: 酷控科技有限责任公司
[usingname]:
[useinfo]:
[id]: 0
[eatway]:
[jiyu]: 0
[message]: <nil>
[qjd]: 30.476747
[canmoney]: 2168.00
[zjd]: 39.926049
[gmoney]: 0
[typeid]: 交通
</ClaimItem>
*/

- (void)initData
{
//    self.lblTraffic.text = locatizedString(@"traffic_car");
//    [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_car"] forState:UIControlStateNormal];
//    self.typeFlag = typeTrafficCar;
    
    self.lblStart.hidden = YES;
    self.lblEnd.hidden = YES;
    self.txtfieldCompany.text = nil;
    self.txtfieldCost.text = nil;
    
    // 显示
    self.txtfieldCompany.text = self.item.usercompany;
    self.txtfieldCost.text = self.item.canmoney;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM"];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    self.date = [formatter dateFromString:self.item.usetime];
    
    [formatter setDateFormat:@"YYYY.MM"];
    self.lblDate.text = [formatter stringFromDate:self.date];
    
    NSString *strValue = locatizedString(@"position_start");
    
    NSString *strStart = [NSString stringWithFormat:@"[%@] %@", strValue, (self.item.qaddress != nil ? self.item.qaddress : @"")];
    [self.btnStart setTitle:strStart forState:UIControlStateNormal];
    self.hasGetStart = YES;
    self.startAddress = self.item.qaddress;
    //
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.item.qjd floatValue];
    coordinate.longitude = [self.item.qwd floatValue];
    self.startLoc = coordinate;
    
    strValue = locatizedString(@"position_end");
    
    NSString *strEnd = [NSString stringWithFormat:@"[%@] %@", strValue, (self.item.zaddress != nil ? self.item.zaddress : @"")];
    [self.btnEnd setTitle:strEnd forState:UIControlStateNormal];
    self.hasGetEnd = YES;
    self.endAddress = self.item.zaddress;
    //
    coordinate.latitude = [self.item.zjd floatValue];
    coordinate.longitude = [self.item.zwd floatValue];
    self.endLoc = coordinate;
    
    if ([self.item.cartype isEqualToString:@"汽车"] == YES)
    {
        self.lblTraffic.text = locatizedString(@"traffic_car");
        [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_car"] forState:UIControlStateNormal];
        self.typeFlag = typeTrafficCar;
    }
    else if ([self.item.cartype isEqualToString:@"火车"] == YES)
    {
        self.lblTraffic.text = locatizedString(@"traffic_train");
        [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_train"] forState:UIControlStateNormal];
        self.typeFlag = typeTrafficTrain;
    }
    else if ([self.item.cartype isEqualToString:@"飞机"] == YES)
    {
        self.lblTraffic.text = locatizedString(@"traffic_flight");
        [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_flight"] forState:UIControlStateNormal];
        self.typeFlag = typeTrafficFlight;
    }
    else if ([self.item.cartype isEqualToString:@"轮船"] == YES)
    {
        self.lblTraffic.text = locatizedString(@"traffic_ship");
        [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_ship"] forState:UIControlStateNormal];
        self.typeFlag = typeTrafficShip;
    }
    else if ([self.item.cartype isEqualToString:@"地铁"] == YES)
    {
        self.lblTraffic.text = locatizedString(@"traffic_metro");
        [self.btnTraffic setBackgroundImage:[UIImage imageNamed:@"icon_traffic_metro"] forState:UIControlStateNormal];
        self.typeFlag = typeTrafficMetro;
    }
    
    if (self.item.imgurl != nil && self.item.imgurl.length > 0)
    {
//        UIImage *img = [UIImage getImageWithImageName:self.item.imgurl];
//        if (img != nil)
//        {
//            self.imgviewClaim.image = img;
//            self.imgCapture = img;
//        }
        
        UIImage *img = [UIImage getImageWithImageName:self.item.imgurl];
        if (img != nil)
        {
            self.imgCapture = img;
            self.imgviewClaim.image = img;
        }
    }
    
    /**********************************************************/
    
    // 是否被拒
    BOOL hasRejected = NO;
    if ([self.item.status isEqualToString:@"pending"] == YES)
    {
        // 等待中
        self.imgviewStatus.image = [UIImage imageNamed:@"img_processing"];
        self.lblStatus.text = @"Pending";
    }
    else if ([self.item.status isEqualToString:@"approving"] == YES)
    {
        // 审核中
        self.imgviewStatus.image = [UIImage imageNamed:@"img_processing"];
        self.lblStatus.text = @"Approving";
    }
    else if ([self.item.status isEqualToString:@"approved"] == YES)
    {
        // 审核通过
        self.imgviewStatus.image = [UIImage imageNamed:@"img_success"];
        self.lblStatus.text = @"Approved";
    }
    else if ([self.item.status isEqualToString:@"reject"] == YES)
    {
        // 被拒
        hasRejected = YES;
    }
    
    // Test
//    hasRejected = YES;
    
    if (hasRejected == YES)
    {
        self.viewStatusHeight.constant = 40;
        self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40);
        
        self.viewStatusBar.hidden = NO;
        self.viewStatus.hidden = YES;
        self.btnSave.hidden = NO;
        self.btnSubmit.hidden = NO;
        
        self.viewTableHeader.userInteractionEnabled = YES;
    }
    else
    {
        self.viewStatusHeight.constant = 0;
        self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        
        self.viewStatusBar.hidden = YES;
        self.viewStatus.hidden = NO;
        self.btnSave.hidden = YES;
        self.btnSubmit.hidden = YES;
        
        self.viewTableHeader.userInteractionEnabled = NO;
    }
    
    self.hasRequestForCompany = NO;
    [self getAllCompany:NO];
    
    self.indexForCompany = 0;
}

- (NSMutableArray *)arrayUserCompany
{
    if (_arrayUserCompany == nil)
    {
        _arrayUserCompany = [[NSMutableArray alloc] init];
        
//        for (int i = 0; i < 8; i++)
//        {
//            CompanyModel *company = [[CompanyModel alloc] init];
//            company.companyinfo = @"Cookov";
//            [_arrayUserCompany addObject:company];
//        }
    }
    
    return _arrayUserCompany;
}

- (void)setImageForClaim:(UIImage *)img
{
    
    
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
    NSString *strValue = locatizedString(@"claim_pic");
    self.lblPhoto.text = strValue;
    
    strValue = locatizedString(@"claim_title_money");
    self.lblCost.text = strValue;
    
    strValue = locatizedString(@"claim_title_company");
    self.lblCompany.text = strValue;
    
    strValue = locatizedString(@"claim_tip_start");
    self.lblStart.text = strValue;
    
    strValue = locatizedString(@"claim_tip_end");
    self.lblEnd.text = strValue;
    
    strValue = locatizedString(@"claim_tip_money");
    self.txtfieldCost.placeholder = strValue;
    
    strValue = locatizedString(@"claim_tip_company");
    self.txtfieldCompany.placeholder = strValue;
    
    strValue = locatizedString(@"save");
    [self.btnSave setTitle:strValue forState:UIControlStateNormal];
    
    strValue = locatizedString(@"sumbit");
    [self.btnSubmit setTitle:strValue forState:UIControlStateNormal];
    
    strValue = locatizedString(@"cancel");
    [self.barbtnCancel setTitle:strValue];
    [self.barbtnCancel_ setTitle:strValue];
    
    strValue = locatizedString(@"done");
    [self.barbtnDone setTitle:strValue];
    [self.barbtnDone_ setTitle:strValue];
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
    [self hideKeyboard];
    
    int status = [self checkClaimContent];
    if (status != 0)
    {
        [self showTipForToast:status];
        return;
    }
    
    // pending
    [self sumbitNewRecord:NO];
}

// 提交
- (IBAction)submitAction
{
    [self hideKeyboard];
    
    int status = [self checkClaimContent];
    if (status != 0)
    {
        [self showTipForToast:status];
        return;
    }
    
    // approving
    [self sumbitNewRecord:YES];
}

// 上传发票
- (IBAction)uploadClaimImage
{
    [self hideKeyboard];
    
    NSString *strTip = locatizedString(@"upload_claim");
    NSString *strCancel = locatizedString(@"cancel");
    NSString *strCamera = locatizedString(@"photo_camera");
    NSString *strAlbum = locatizedString(@"photo_album");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:strTip
                                                             delegate:self
                                                    cancelButtonTitle:strCancel
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:strCamera, strAlbum, nil];
    actionSheet.tag = kTag + 1;
    [actionSheet showInView:self.view.window];
}

- (IBAction)showPopViewForDate
{
    [self hideKeyboard];
    
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

- (IBAction)cancelPopViewForClaim
{
    [self.viewTranslucence_ removeFromSuperview];
}

- (IBAction)donePopViewForClaim
{
    NSInteger index = [self.claimPicker selectedRowInComponent:0];
    self.indexForCompany = index;
    
    CompanyModel *company = self.arrayUserCompany[index];
    self.txtfieldCompany.text = company.companyinfo;
    
    [self.viewTranslucence_ removeFromSuperview];
}

- (IBAction)selectCompany
{
    [self hideKeyboard];
    
    if (self.arrayUserCompany != nil && self.arrayUserCompany.count > 0)
    {
        [self.view addSubview:self.viewTranslucence_];
    }
    else
    {
        if (self.hasRequestForCompany == YES)
        {
            // 之前已请求过公司
            //[self toast:@"暂无公司,请先申请加入"];
            
            NSString *strTip = locatizedString(@"no_company");
            [self toast:strTip];
        }
        else
        {
            // 之前未请求过公司 or 之前的请求还未完成
            
            [self getAllCompany:YES];
        }
    }
}


#pragma mark - Custom

- (void)hidePopViewForDate
{
    [self.viewTranslucence removeFromSuperview];
    
}

- (void)hidePopViewForClaim
{
    [self.viewTranslucence_ removeFromSuperview];
    
}

- (void)getStartLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address
{
    self.startLoc = location;
    self.startAddress = address;
    self.hasGetStart = YES;
    
    self.lblStart.hidden = YES;
    
    NSString *strValue = locatizedString(@"position_start");
    
    NSString *strStart = [NSString stringWithFormat:@"[%@] %@", strValue, address];
    [self.btnStart setTitle:strStart forState:UIControlStateNormal];
}

- (void)getEndLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address
{
    self.endLoc = location;
    self.endAddress = address;
    self.hasGetEnd = YES;
    
    self.lblEnd.hidden = YES;
    
    NSString *strValue = locatizedString(@"position_end");
    
    NSString *strEnd = [NSString stringWithFormat:@"[%@] %@", strValue, address];
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

// 0-ok 1-日期不能为空 2-交通工具类型不能为空 3-起始点不能为空 4-终点不能为空 5-金额不能为空 6-公司不能为空 7-发票图片不能为空
- (int)checkClaimContent
{
    if (self.date == nil)
    {
        return 1;
    }
    
    if (self.typeFlag == typeTrafficOther)
    {
        return 2;
    }
    
    if (self.hasGetCurrent == NO && self.hasGetStart == NO)
    {
        return 3;
    }
    
    if (self.hasGetEnd == NO)
    {
        return 4;
    }
    
    if (self.txtfieldCost.text != nil && self.txtfieldCost.text.length > 0)
    {
        //
    }
    else
    {
        return 5;
    }
    
//    if (self.txtfieldCompany.text != nil && self.txtfieldCompany.text.length > 0)
//    {
//        //
//    }
//    else
//    {
//        return 6;
//    }
    
//    if (self.imgCapture == nil)
//    {
//        return 7;
//    }
    
    return 0;
}

- (void)showTipForToast:(int)status
{
    switch (status) {
        case 1: {
            //[self toast:@"日期不能为空"];
            
            NSString *strTip = locatizedString(@"claim_date_nil");
            [self toast:strTip];
            break;
        }
        case 2: {
            //[self toast:@"交通工具类型不能为空"];
            
            NSString *strTip = locatizedString(@"claim_traffic_type_nil");
            [self toast:strTip];
            break;
        }
        case 3: {
            //[self toast:@"起始点不能为空"];
            
            NSString *strTip = locatizedString(@"claim_start_nil");
            [self toast:strTip];
            break;
        }
        case 4: {
            //[self toast:@"终点不能为空"];
            
            NSString *strTip = locatizedString(@"claim_end_nil");
            [self toast:strTip];
            break;
        }
        case 5: {
            //[self toast:@"金额不能为空"];
            
            NSString *strTip = locatizedString(@"claim_money_nil");
            [self toast:strTip];
            break;
        }
        case 6: {
            //[self toast:@"公司不能为空"];
            
            NSString *strTip = locatizedString(@"claim_company_nil");
            [self toast:strTip];
            break;
        }
        default:
            break;
    }
}


#pragma mark - HttpRequest

// 上传发票请求
- (void)requestForUploadClaimImage:(UIImage *)img
{
    //
}

- (void)getAllCompany:(BOOL)showLoading
{
    if (showLoading == YES)
    {
        UserManager *userManager = [UserManager sharedInstance];
        if (userManager.arrayCompany != nil)
        {
            [self.arrayUserCompany removeAllObjects];
            self.arrayUserCompany = userManager.arrayCompany;
            
            if (self.arrayUserCompany.count == 0)
            {
                //[self toast:@"暂无公司,请先申请加入"];
                
                NSString *strTip = locatizedString(@"no_company");
                [self toast:strTip];
            }
            return;
        }
    }
    
    if (showLoading == YES)
    {
        NSString *strLoading = locatizedString(@"loading");
        [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    }
    
    [InterfaceManager getUserCompany:^(BOOL isSucceed, NSString *message, id data) {
        
        if (showLoading == YES)
        {
            [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        }
        
        self.hasRequestForCompany = YES;
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"获取成功");
                    
                    NSArray *array = response.data;
                    NSLog(@"array:%@", array);
                    
                    if (array != nil && array.count > 0)
                    {
                        [self.arrayUserCompany removeAllObjects];
                        
                        for (NSDictionary *dic in array)
                        {
                            NSError *error;
                            CompanyModel *item = [[CompanyModel alloc] initWithDictionary:dic error:&error];
                            if (item != nil)
                            {
                                [self.arrayUserCompany addObject:item];
                            }
                        }   // for
                        
                        NSLog(@"arrayUserCompany:%@", self.arrayUserCompany);
                        
                        // 保存用户公司
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayCompany = [NSMutableArray arrayWithArray:self.arrayUserCompany];
                        
                        if (showLoading == YES)
                        {
                            [self.claimPicker reloadAllComponents];
                            [self.view addSubview:self.viewTranslucence_];
                        }
                    }
                    else
                    {
                        // 无发票类型数据
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayCompany = [[NSMutableArray alloc] init];
                        
                        if (showLoading == YES)
                        {
                            //[self toast:@"暂无公司,请先申请加入"];
                            
                            NSString *strTip = locatizedString(@"no_company");
                            [self toast:strTip];
                        }
                    }
                }
                else
                {
                    NSLog(@"获取失败");
                    //[self toast:@"获取失败"];
                    
                    if (showLoading == YES)
                    {
                        //[self toast:@"获取失败"];
                        
                        NSString *strTip = locatizedString(@"no_company");
                        [self toast:strTip];
                    }
                }
            }
            else
            {
                // 无公司数据
                NSString *strTip = locatizedString(@"no_company");
                [self toast:strTip];
            }
        }
        else
        {
            if (message != nil && message.length > 0)
            {
                //[self toast:message];
                
                if (showLoading == YES)
                {
                    [self toast:message];
                }
            }
            else
            {
                //[self toast:@"获取失败"];
                
                if (showLoading == YES)
                {
                    //[self toast:@"获取失败"];
                    
                    NSString *strTip = locatizedString(@"loadFail");
                    [self toast:strTip];
                }
            }
        }
        
    }];
}

- (void)sumbitNewRecord:(BOOL)status
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSString *strDate = [formatter stringFromDate:self.date];
    
    BOOL startFlag = NO;
    if (self.startAddress != nil)
    {
        // 用户手动取选了起点...
        startFlag = YES;
    }
    
    // 传参对象...~!@
    ClaimNewModel *claim = [[ClaimNewModel alloc] init];
    // 1.发票类型
    claim.typeid_ = @"1";   // 12 1
    // 2.日期
    claim.time = strDate;
    // 3.金额
    claim.money = [NSString stringWithFormat:@"%@", self.txtfieldCost.text];
    
    // 4.起点位置信息
    if (startFlag == YES)
    {
        claim.qjd = [NSString stringWithFormat:@"%f", self.startLoc.latitude];
        claim.qwd = [NSString stringWithFormat:@"%f", self.startLoc.longitude];
        claim.qaddress = self.startAddress;
    }
    else
    {
        claim.qjd = [NSString stringWithFormat:@"%f", self.currentLocation.latitude];
        claim.qwd = [NSString stringWithFormat:@"%f", self.currentLocation.longitude];
        claim.qaddress = self.currentAddress;
    }
    
    // 5.终点位置信息
    claim.zjd = [NSString stringWithFormat:@"%f", self.endLoc.latitude];
    claim.zwd = [NSString stringWithFormat:@"%f", self.endLoc.longitude];
    claim.zaddress = self.endAddress;
    
    // 6.交通类型
    if (self.typeFlag == typeTrafficCar)
    {
        claim.cartype = @"汽车";
    }
    else if (self.typeFlag == typeTrafficTrain)
    {
        claim.cartype = @"火车";
    }
    else if (self.typeFlag == typeTrafficFlight)
    {
        claim.cartype = @"飞机";
    }
    else if (self.typeFlag == typeTrafficShip)
    {
        claim.cartype = @"轮船";
    }
    else if (self.typeFlag == typeTrafficMetro)
    {
        claim.cartype = @"地铁";
    }
    
    // 7.用户公司id
    if (self.txtfieldCompany.text != nil && self.txtfieldCompany.text.length > 0)
    {
        if (self.arrayUserCompany != nil && self.arrayUserCompany.count > 0)
        {
            if (self.indexForCompany >= 0 && self.indexForCompany < self.arrayUserCompany.count)
            {
                CompanyModel *company = self.arrayUserCompany[self.indexForCompany];
                //    claim.company = company.id;
                //    claim.usercompany = company.companyinfo;
                
                if ([company.companyinfo isEqualToString:self.txtfieldCompany.text] == YES)
                {
                    claim.company = company.id;
                    claim.usercompany = company.companyinfo;
                }
                else
                {
                    BOOL isOK = NO;
                    
                    for (int i = 0; i < self.arrayUserCompany.count; i++)
                    {
                        CompanyModel *item = self.arrayUserCompany[i];
                        if ([item.companyinfo isEqualToString:self.txtfieldCompany.text] == YES)
                        {
                            claim.company = item.id;
                            claim.usercompany = item.companyinfo;
                            isOK = YES;
                            break;
                        }
                    }
                    
                    if (isOK == NO)
                    {
                        claim.company = nil;
                        claim.usercompany = self.txtfieldCompany.text;
                    }
                }
            }
        }
    }
    
    // 8.发票图片
    if (self.imgCapture != nil)
    {
        // 获取图片保存在本地的全路径
        NSString *strTime = [NSString stringWithDate:[NSDate date] formater:@"yyyyMMddHHmmssSSS"];
        NSString *strImgName = [NSString stringWithFormat:@"camclaim_%@", strTime];
        // 保存至doc
        NSString *imgPath = [UIImage saveImage:self.imgCapture withName:strImgName];
        //
        //claim.imgurl = imgPath;
        
        if (imgPath != nil)
        {
            claim.imgurl = strImgName;
        }
    }
    
    // 9.状态
    if (status == YES)
    {
        claim.status = @"1";
    }
    else
    {
        claim.status = @"0";
    }
    
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager submitUserNewClaimForTraffic:claim completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"提交成功");
                    
                    //[self toast:@"新增发票成功"];
                    
                    NSString *strTip = locatizedString(@"sumbitSuccess");
                    [self toast:strTip];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAddNewClaimSuccess object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    NSLog(@"提交失败");
                    //[self toast:@"提交失败"];
                    
                    NSString *strTip = locatizedString(@"submitFail");
                    [self toast:strTip];
                }
            }
            else
            {
                NSLog(@"提交失败");
                //[self toast:@"提交失败"];
                
                NSString *strTip = locatizedString(@"submitFail");
                [self toast:strTip];
            }
        }
        else
        {
            if (message != nil && message.length > 0)
            {
                [self toast:message];
            }
            else
            {
                //[self toast:@"提交失败"];
                
                NSString *strTip = locatizedString(@"submitFail");
                [self toast:strTip];
            }
        }
        
    }];
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
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                    
                    NSString *strValue = locatizedString(@"position_start");
                    
                    NSString *strStart = [NSString stringWithFormat:@"[%@] %@", strValue, wself.currentAddress];
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
        //[wself toast:@"无法定位当前位置"];
        
        NSString *strTip = locatizedString(@"map_location_fail");
        [wself toast:strTip];
        
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
                
                NSString *strValue = locatizedString(@"position_start");
                
                NSString *strStart = [NSString stringWithFormat:@"[%@] %@", strValue, wself.currentAddress];
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
            self.imgCapture = imgPicker;
            
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


#pragma mark - UIPickerViewDelegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayUserCompany.count;
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kScreenWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 46;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CompanyModel *company = self.arrayUserCompany[row];
    return company.companyinfo;
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    CompanyModel *company = self.arrayUserCompany[row];
//}


@end
