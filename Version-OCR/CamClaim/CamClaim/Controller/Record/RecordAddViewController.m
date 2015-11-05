//
//  RecordAddViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/8.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "RecordAddViewController.h"
#import "ClaimTypeModel.h"
#import "CompanyModel.h"
#import "ClaimNewModel.h"

// 选择类型
typedef NS_ENUM(NSInteger, pickerContentType) {
    pickerContentTypeDate = 0,      // 日期
    pickerContentTypeClaimType,     // 发票类型
    pickerContentTypeCompany,       // 公司
    pickerContentTypeNone = -1      // 未选择类型
};


@interface RecordAddViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *viewTableHeader;
@property (nonatomic, strong) IBOutlet UIView *viewBg;
@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) IBOutlet UITextField *textfieldName;
@property (nonatomic, strong) IBOutlet UITextField *textfieldUse;
@property (nonatomic, strong) IBOutlet UITextField *textfieldMoney;
@property (nonatomic, strong) IBOutlet UITextField *textfieldTime;
@property (nonatomic, strong) IBOutlet UITextField *textfieldLocation;
@property (nonatomic, strong) IBOutlet UITextField *textfieldBill;
@property (nonatomic, strong) IBOutlet UITextField *textfieldCompany;

// 半透明遮罩
@property (nonatomic, strong) UIView *viewTranslucence;

//
@property (nonatomic, strong) IBOutlet UIView *viewPicker;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnCancel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnDone;

@property (nonatomic, strong) NSMutableArray *arrayClaimType;
@property (nonatomic, strong) NSMutableArray *arrayUserCompany;

// 半透明遮罩
@property (nonatomic, strong) UIView *viewTranslucence_;

//
@property (nonatomic, strong) IBOutlet UIView *viewClaimPicker;
@property (nonatomic, strong) IBOutlet UIPickerView *claimPicker;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnCancel_;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnDone_;

@property pickerContentType pickType;
@property (nonatomic, copy) NSString *claimid;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *strPick;

- (IBAction)cancelPopViewForTime;
- (IBAction)donePopViewForTime;

- (IBAction)cancelPopViewForClaim;
- (IBAction)donePopViewForClaim;

- (IBAction)btnTouchAction:(id)sender;

@end

@implementation RecordAddViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"New Record";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    // 保存
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:@"Save" forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    //self.navView.btnMoreWidth.constant = 60;
    
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)236/255 blue:(CGFloat)236/255 alpha:1];
    
    [self initView];
    
    [self initPopViewForDate];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    [self initData];
    
    // 直接弹出键盘
    //[self.textfieldUse becomeFirstResponder];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHeader;
    
    self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, 480);
    self.viewBg.backgroundColor = [UIColor whiteColor];
    
    self.textfieldName.returnKeyType = UIReturnKeyNext;
    self.textfieldUse.returnKeyType = UIReturnKeyNext;
    self.textfieldMoney.returnKeyType = UIReturnKeyNext;
    self.textfieldLocation.returnKeyType = UIReturnKeyDone;
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
    [formatter setDateFormat:@"YYYY/MM/dd"];
    self.textfieldTime.text = [formatter stringFromDate:[NSDate date]];
    
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
    // 先请求到数据
    [self getAllClaimType:NO];
    [self getAllCompany:NO];
    
    self.pickType = pickerContentTypeDate;
    
    UserManager *userManager = [UserManager sharedInstance];
    if (userManager.userInfo.realname != nil && userManager.userInfo.realname.length > 0)
    {
        self.textfieldName.text = userManager.userInfo.realname;
    }
}

- (NSMutableArray *)arrayClaimType
{
    if (_arrayClaimType == nil)
    {
        _arrayClaimType = [[NSMutableArray alloc] init];
    }
    
    return _arrayClaimType;
}

- (NSMutableArray *)arrayUserCompany
{
    if (_arrayUserCompany == nil)
    {
        _arrayUserCompany = [[NSMutableArray alloc] init];
    }
    
    return _arrayUserCompany;
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

// 返回
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 保存
- (void)moreAction
{
    int status = [self checkContent];
    if (status != 0)
    {
        switch (status) {
            case 1:
                [self toast:@"姓名不能为空"];
                break;
            case 2:
                [self toast:@"发票事由不能为空"];
                break;
            case 3:
                [self toast:@"金额不能为空"];
                break;
            case 4:
                [self toast:@"日期不能为空"];
                break;
            case 5:
                [self toast:@"发票类型不能为空"];
                break;
            case 6:
                [self toast:@"公司名称不能为空"];
                break;
            case 7:
                [self toast:@"地点不能为空"];
                break;
            default:
                break;
        }
        
        return;
    }
    
    // 提交信息
    [self sumbitNewRecord];
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

// 0-合法 1-姓名为空 2-事由为空 3-金额为空 4-日期为空 5-发票类型为空 6-公司名为空 7-地点为空
- (int)checkContent
{
    if ([NSString checkContent:self.textfieldName.text] == NO)
    {
        return 1;
    }
    
    if ([NSString checkContent:self.textfieldUse.text] == NO)
    {
        return 2;
    }
    
    if ([NSString checkContent:self.textfieldMoney.text] == NO)
    {
        return 3;
    }
    
    if ([NSString checkContent:self.textfieldTime.text] == NO)
    {
        return 4;
    }

    if ([NSString checkContent:self.textfieldBill.text] == NO)
    {
        return 5;
    }
    
    if ([NSString checkContent:self.textfieldCompany.text] == NO)
    {
        return 6;
    }

    if ([NSString checkContent:self.textfieldLocation.text] == NO)
    {
        return 7;
    }
    
    return 0;
}


#pragma mark - Request

- (void)sumbitNewRecord
{
    ClaimNewModel *claim = [[ClaimNewModel alloc] init];
    claim.client = self.textfieldName.text;
    claim.purpose = self.textfieldUse.text;
    claim.money = self.textfieldMoney.text;
    claim.time = self.textfieldTime.text;
    //claim.claimType = self.textfieldBill.text;
    claim.claimType = self.claimid;
    //claim.company = self.textfieldCompany.text;
    claim.company = self.companyid;
    claim.location = self.textfieldLocation.text;
    
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager submitUserNewClaim:claim completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                // {"status":1,"message":"提交成功","data":null,"total":0}
                
                /*
                2015-09-12 12:34:34.884 CamClaim[94619:2132475] [DEBUG] ...>>>...requestUrl:http://115.29.105.23:8080/sales/content/addContenByPhone
                2015-09-12 12:34:34.884 CamClaim[94619:2132475] [DEBUG]
                request body start ----------------
                {"typeid":"13","userid":"46","client":"夏天","using":"交通费","time":"2015.09.10","companyid":"15","localtion":"香港","money":"168"}
                request body end ----------------
                2015-09-12 12:34:35.003 CamClaim[94619:2132475] [DEBUG]
                -----------------------------------
                ...<statusCode:200>...<responseString:>
                {"status":1,"message":"提交成功","data":null,"total":0}
                ----------------------------
                */
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"提交成功");
                    
                    [self toast:@"新增发票成功"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAddNewClaimSuccess object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    NSLog(@"提交失败");
                    [self toast:@"提交失败"];
                }
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
                [self toast:@"提交失败"];
            }
        }
        
    }];
}


#pragma mark - BtnTouchAction

- (IBAction)btnTouchAction:(id)sender
{
    [self hideKeyboard];
    
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    if (tag == kTag)
    {
        // 选择日期
        [self.view addSubview:self.viewTranslucence];
    }
    else if (tag == kTag + 1)
    {
        // 发票类型
        //[self getAllClaimType:YES];
        
        if (self.arrayClaimType != nil && self.arrayClaimType.count > 0)
        {
            [self showClaimPicker:pickerContentTypeClaimType];
        }
        else
        {
            [self getAllClaimType:YES];
        }
    }
    else if (tag == kTag + 2)
    {
        // 公司
        //[self getAllCompany:YES];
        
        if (self.arrayUserCompany != nil && self.arrayUserCompany.count > 0)
        {
            [self showClaimPicker:pickerContentTypeCompany];
        }
        else
        {
            [self getAllCompany:YES];
        }
    }
}

- (IBAction)cancelPopViewForTime
{
    [self.viewTranslucence removeFromSuperview];
}

- (IBAction)donePopViewForTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    //[formatter setDateFormat:@"YYYY.MM.dd"];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSString *strDate = [formatter stringFromDate:self.datePicker.date];
    self.textfieldTime.text = strDate;
    
    [self.viewTranslucence removeFromSuperview];
}

- (IBAction)cancelPopViewForClaim
{
    [self.viewTranslucence_ removeFromSuperview];
}

- (IBAction)donePopViewForClaim
{
    if (self.pickType == pickerContentTypeClaimType)
    {
        NSInteger index = [self.claimPicker selectedRowInComponent:0];
        ClaimTypeModel *claim = self.arrayClaimType[index];
        self.strPick = claim.typename_;
        self.claimid = claim.id;
        
        self.textfieldBill.text = self.strPick;
        self.strPick = nil;
    }
    else if (self.pickType == pickerContentTypeCompany)
    {
        NSInteger index = [self.claimPicker selectedRowInComponent:0];
        CompanyModel *company = self.arrayUserCompany[index];
        self.strPick = company.companyinfo;
        self.companyid = company.id;
        
        self.textfieldCompany.text = self.strPick;
        self.strPick = nil;
    }
    
    [self.viewTranslucence_ removeFromSuperview];
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

- (void)showClaimPicker:(pickerContentType)type
{
    self.pickType = type;
    [self.claimPicker reloadAllComponents];
    [self.claimPicker selectRow:0 inComponent:0 animated:YES];
    [self.view addSubview:self.viewTranslucence_];
}


#pragma mark - HttpRequest

- (void)getAllClaimType:(BOOL)showLoading
{
    if (showLoading == YES)
    {
        // 手动请求
        UserManager *userManager = [UserManager sharedInstance];
        if (userManager.arrayClaim != nil)
        {
            [self.arrayClaimType removeAllObjects];
            self.arrayClaimType = userManager.arrayClaim;
            
            if (self.arrayClaimType.count == 0)
            {
                [self toast:@"暂无发票类型"];
            }
            return;
        }
    }
    
    /*******************************************************/
    
    if (showLoading == YES)
    {
        [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    }
    
    [InterfaceManager getClaimType:^(BOOL isSucceed, NSString *message, id data) {
        
        if (showLoading == YES)
        {
            [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        }
        
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
                        [self.arrayClaimType removeAllObjects];
                        
                        for (NSDictionary *dic in array)
                        {
                            NSError *error;
                            ClaimTypeModel *claim = [[ClaimTypeModel alloc] initWithDictionary:dic error:&error];
                            if (claim != nil)
                            {
                                claim.typename_ = dic[@"typename"];
                                [self.arrayClaimType addObject:claim];
                            }
                        }   // for
                        
                        //NSLog(@"claimType:%@", self.arrayClaimType);
                        
                        // 保存用户发票类型
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayClaim = [NSMutableArray arrayWithArray:self.arrayClaimType];
                        
                        if (showLoading == YES)
                        {
                            [self showClaimPicker:pickerContentTypeClaimType];
                        }
                    }
                    else
                    {
                        // 无发票类型数据
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayClaim = [[NSMutableArray alloc] init];
                    }
                }
                else
                {
                    NSLog(@"获取失败");
                    //[self toast:@"提交失败"];
                    
                    if (showLoading == YES)
                    {
                        [self toast:@"获取失败"];
                    }
                }
            }
            else
            {
                // 无发票类型数据
                
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
                    [self toast:@"获取失败"];
                }
            }
        }
        
    }];
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
                [self toast:@"暂无公司,请添加"];
            }
            return;
        }
    }
    
    if (showLoading == YES)
    {
        [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    }
    
    [InterfaceManager getUserCompany:^(BOOL isSucceed, NSString *message, id data) {
        
        if (showLoading == YES)
        {
            [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        }
        
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
                        
                        // 保存用户发票类型
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayCompany = [NSMutableArray arrayWithArray:self.arrayUserCompany];
                        
                        if (showLoading == YES)
                        {
                            [self showClaimPicker:pickerContentTypeCompany];
                        }
                    }
                    else
                    {
                        // 无发票类型数据
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayCompany = [[NSMutableArray alloc] init];
                        
                        if (showLoading == YES)
                        {
                            [self toast:@"暂无公司,请添加"];
                        }
                    }
                }
                else
                {
                    NSLog(@"获取失败");
                    //[self toast:@"获取失败"];
                    
                    if (showLoading == YES)
                    {
                        [self toast:@"获取失败"];
                    }
                }
            }
            else
            {
                // 无公司数据
                
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
                    [self toast:@"获取失败"];
                }
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
    //return self.arrayClaim.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellID = @"cellRecord";
//    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil)
//    {
//        cell = [RecordCell cellFromNib];
//    }
//    
//    ClaimItem *item = self.arrayClaim[indexPath.row];
//    [cell configWithData:item];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
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
    if (self.pickType == pickerContentTypeClaimType)
    {
        return self.arrayClaimType.count;
    }
    else if (self.pickType == pickerContentTypeCompany)
    {
        return self.arrayUserCompany.count;
    }
    
    return 0;
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
    if (self.pickType == pickerContentTypeClaimType)
    {
        ClaimTypeModel *claim = self.arrayClaimType[row];
        return claim.typename_;
    }
    else if (self.pickType == pickerContentTypeCompany)
    {
        CompanyModel *company = self.arrayUserCompany[row];
        return company.companyinfo;
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickType == pickerContentTypeClaimType)
    {
        ClaimTypeModel *claim = self.arrayClaimType[row];
        self.strPick = claim.typename_;
    }
    else if (self.pickType == pickerContentTypeCompany)
    {
        CompanyModel *company = self.arrayUserCompany[row];
        self.strPick = company.companyinfo;
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textfieldName)
    {
        [self.textfieldName resignFirstResponder];
        [self.textfieldUse becomeFirstResponder];
    }
    else if (textField == self.textfieldUse)
    {
        [self.textfieldUse resignFirstResponder];
        [self.textfieldMoney becomeFirstResponder];
    }
    else if (textField == self.textfieldMoney)
    {
        [self.textfieldMoney resignFirstResponder];
        [self.textfieldLocation becomeFirstResponder];
    }
    else if (textField == self.textfieldLocation)
    {
        [self.textfieldLocation resignFirstResponder];
    }
    
    return YES;
}


@end
