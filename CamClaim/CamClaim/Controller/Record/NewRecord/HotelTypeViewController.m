//
//  HotelTypeViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "HotelTypeViewController.h"
#import "MapViewController.h"
#import "CompanyModel.h"

@interface HotelTypeViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayList;

@property (nonatomic, strong) IBOutlet UIView *viewTableHeader;

@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewClaim;

@property (nonatomic, strong) IBOutlet UILabel *lblStart;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldHotel;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldUse;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldDateNumber;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldCost;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldCompany;

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

@property (nonatomic, strong) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, assign) CLLocationCoordinate2D startLoc;
@property (nonatomic, copy) NSString *startAddress;
@property BOOL hasGetStart;

@property BOOL hasRequestForCompany;
@property NSInteger indexForCompany;

// Language
@property (nonatomic, strong) IBOutlet UILabel *lblHotel;
@property (nonatomic, strong) IBOutlet UILabel *lblPurpose;
@property (nonatomic, strong) IBOutlet UILabel *lblDays;
@property (nonatomic, strong) IBOutlet UILabel *lblCost;
@property (nonatomic, strong) IBOutlet UILabel *lblCompany;

- (IBAction)getUserLocation:(id)sender;

- (IBAction)saveAction;
- (IBAction)submitAction;

- (IBAction)selectCompany;

@end

@implementation HotelTypeViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navView.lblTitle.text = @"住宿";
    
    NSString *strValue = locatizedString(@"type_hotel");
    self.navView.lblTitle.text = strValue;
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
        
    [self initView];
    
    [self initPopViewForDate];
    
    [self initViewWithAutoLayout];
    
    [self initData];
    
    [self settingLanguage];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHeader;
    
    self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);   // 460
    
    if (kScreenHeight - 64 <= 508)
    {
        self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, 508);
    }
    
    UIImage *img = [UIImage imageNamed:@"btn_save"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [self.btnSave setBackgroundImage:img forState:UIControlStateNormal];
    
    UIImage *img_ = [UIImage imageNamed:@"btn_resubmit"];
    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [self.btnSubmit setBackgroundImage:img_ forState:UIControlStateNormal];
    
    if (self.imgCapture != nil)
    {
        self.imgviewClaim.image = self.imgCapture;
    }
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

- (void)initData
{
    self.date = [NSDate date];
    
    self.hasRequestForCompany = NO;
    [self getAllCompany:NO];
    
    //self.indexForCompany = 0;
    self.indexForCompany = -1;
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
    NSString *strValue = locatizedString(@"claim_title_hotel");
    self.lblHotel.text = strValue;
    
    strValue = locatizedString(@"claim_title_purpose");
    self.lblPurpose.text = strValue;
    
    strValue = locatizedString(@"claim_title_days");
    self.lblDays.text = strValue;
    
    strValue = locatizedString(@"claim_title_money");
    self.lblCost.text = strValue;
    
    strValue = locatizedString(@"claim_title_company");
    self.lblCompany.text = strValue;
    
    strValue = locatizedString(@"claim_tip_start");
    self.lblStart.text = strValue;
    
    
    strValue = locatizedString(@"claim_tip_hotel");
    self.txtfieldHotel.placeholder = strValue;
    
    strValue = locatizedString(@"claim_tip_purpose");
    self.txtfieldUse.placeholder = strValue;
    
    strValue = locatizedString(@"claim_tip_days");
    self.txtfieldDateNumber.placeholder = strValue;
    
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


#pragma mark -

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

- (IBAction)getUserLocation:(id)sender
{
    // 起始位置
    MapViewController *mapVC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapVC.startFlag = YES;
    mapVC.beforeVC = self;
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (IBAction)cancelPopViewForClaim
{
    [self hideKeyboard];
    
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
    
    self.lblStart.text = address;
}

// 0-ok 1-日期不能为空 2-起始点不能为空 3-酒店不能为空 4-用途不能为空 5-住宿天数不能为空 6-金额不能为空 7-用户公司不能为空 8-发票图片不能为空
- (int)checkClaimContent
{
    if (self.date == nil)
    {
        return 1;
    }
    
    if (self.hasGetStart == NO)
    {
        return 2;
    }
    
    if (self.txtfieldHotel.text != nil && self.txtfieldHotel.text.length > 0)
    {
        //
    }
    else
    {
        return 3;
    }
    
    if (self.txtfieldUse.text != nil && self.txtfieldUse.text.length > 0)
    {
        //
    }
    else
    {
        return 4;
    }
    
    if (self.txtfieldDateNumber.text != nil && self.txtfieldDateNumber.text.length > 0)
    {
        //
    }
    else
    {
        return 5;
    }
    
    if (self.txtfieldCost.text != nil && self.txtfieldCost.text.length > 0)
    {
        //
    }
    else
    {
        return 6;
    }
    
//    if (self.txtfieldCompany.text != nil && self.txtfieldCompany.text.length > 0)
//    {
//        //
//    }
//    else
//    {
//        return 7;
//    }
    
//    if (self.imgCapture == nil)
//    {
//        return 8;
//    }
    
    return 0;
}

- (void)showTipForToast:(int)status
{
    switch (status) {
        case 1: {
            [self toast:@"日期不能为空"];
            
            NSString *strTip = locatizedString(@"claim_date_nil");
            [self toast:strTip];
            break;
        }
        case 2: {
            [self toast:@"起始点不能为空"];
            
            NSString *strTip = locatizedString(@"claim_start_nil");
            [self toast:strTip];

            break;
        }
        case 3: {
            [self toast:@"酒店名称不能为空"];
            
            NSString *strTip = locatizedString(@"claim_hotel_nil");
            [self toast:strTip];

            break;
        }
        case 4: {
            [self toast:@"用途不能为空"];
            
            NSString *strTip = locatizedString(@"claim_purpose_nil");
            [self toast:strTip];

            break;
        }
        case 5: {
            [self toast:@"住宿天数不能为空"];
            
            NSString *strTip = locatizedString(@"claim_days_nil");
            [self toast:strTip];

            break;
        }
        case 6: {
            [self toast:@"金额不能为空"];
            
            NSString *strTip = locatizedString(@"claim_money_nil");
            [self toast:strTip];

            break;
        }
        case 7: {
            [self toast:@"公司不能为空"];
            
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

/*
2015-10-27 11:43:50.299 CamClaimPro[1476:427317] [DEBUG] request:{
    cartype = "";
    client = "";
    clientcompany = "";
    companyid = 52;
    days = 5;
    eatway = "";
    imgurl = "/var/mobile/Containers/Data/Application/18AE110B-ABAB-4AD7-8ABE-B5DA616C448F/Documents/camclaim_20151027114350133";
    jd = "30.474617";
    localtion = "";
    money = 4200;
    qaddress = "\U4e2d\U56fd\U6e56\U5317\U7701\U6b66\U6c49\U5e02\U6d2a\U5c71\U533a\U8f6f\U4ef6\U56ed\U8def11\U53f7";
    remark = "";
    status = 1;
    store = "\U5e0c\U814a\U4eba\U9152\U5e97";
    time = "2015/10/26";
    typeid = 13;
    usercompany = "\U9177\U63a7\U79d1\U6280\U6709\U9650\U8d23\U4efb\U516c\U53f8";
    userid = 22;
    using = "\U5de5\U7a0b\U7ef4\U62a4";
    usingname = "";
    wd = "114.407439";
    zaddress = "";
    zjd = "";
    zwd = "";
}
2015-10-27 11:43:50.301 CamClaimPro[1476:427317] [DEBUG] ...>>>...requestUrl:http://115.29.105.23:8080/sales/content/addContenByPhone
2015-10-27 11:43:50.303 CamClaimPro[1476:427317] [DEBUG]
request body start ----------------
{"userid":"22","status":"1","money":"4200","time":"2015\/10\/26","qaddress":"中国湖北省武汉市洪山区软件园路11号","zaddress":"","days":"5","zwd":"","store":"希腊人酒店","imgurl":"\/var\/mobile\/Containers\/Data\/Application\/18AE110B-ABAB-4AD7-8ABE-B5DA616C448F\/Documents\/camclaim_20151027114350133","client":"","wd":"114.407439","cartype":"","localtion":"","usercompany":"酷控科技有限责任公司","using":"工程维护","clientcompany":"","usingname":"","eatway":"","companyid":"52","zjd":"","typeid":"13","jd":"30.474617","remark":""}
request body end ----------------
2015-10-27 11:43:50.489 CamClaimPro[1476:427317] [DEBUG]
-----------------------------------
...<statusCode:200>...<responseString:>
{"status":1,"message":"提交成功","data":null,"total":0}
----------------------------
*/

- (void)sumbitNewRecord:(BOOL)status
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSString *strDate = [formatter stringFromDate:self.date];
    
    BOOL startFlag = NO;
    if (self.hasGetStart == YES && self.startAddress != nil)
    {
        // 用户手动取选了起点...
        startFlag = YES;
    }
    
    // 传参对象...~!@
    ClaimNewModel *claim = [[ClaimNewModel alloc] init];
    // 1.发票类型
    claim.typeid_ = @"2";   // 13 2
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
    
    // 5.酒店名称
    claim.store = self.txtfieldHotel.text;
    
    // 6.用途
    claim.purpose = self.txtfieldUse.text;
    
    // 7.天数
    claim.days = self.txtfieldDateNumber.text;
    
    // 8.用户公司id
//    CompanyModel *company = self.arrayUserCompany[self.indexForCompany];
//    claim.company = company.id;
//    claim.usercompany = company.companyinfo;
    
    if (self.txtfieldCompany.text != nil && self.txtfieldCompany.text.length > 0 && self.indexForCompany >= 0)
    {
        CompanyModel *company = self.arrayUserCompany[self.indexForCompany];
        claim.company = company.id;
        claim.usercompany = company.companyinfo;
    }
    
    // 9.发票图片
    if (self.imgCapture != nil)
    {
//        NSData *dataImg = UIImageJPEGRepresentation(self.imgCapture, 0.8f);
//        NSString *stringBase64 = [dataImg base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        claim.imgurl = stringBase64;
        
        // [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
        
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
    
    // 10.状态
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
    
    [InterfaceManager submitUserNewClaimForHotel:claim completion:^(BOOL isSucceed, NSString *message, id data) {
        
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


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kTag)
    {
        //
        
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
