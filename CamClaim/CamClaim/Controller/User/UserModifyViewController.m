//
//  UserModifyViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "UserModifyViewController.h"
#import "UserBaseInfo.h"

@interface UserModifyViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *viewTableHeader;
@property (nonatomic, strong) IBOutlet UIView *viewBg;
@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) IBOutlet UITextField *textfieldName;
@property (nonatomic, strong) IBOutlet UITextField *textfieldNickname;
@property (nonatomic, strong) IBOutlet UITextField *textfieldEmail;
@property (nonatomic, strong) IBOutlet UITextField *textfieldCountry;
@property (nonatomic, strong) IBOutlet UITextField *textfieldPhone;
@property (nonatomic, strong) IBOutlet UITextField *textfieldCompany;
@property (nonatomic, strong) IBOutlet UITextField *textfieldDepartment;
@property (nonatomic, strong) IBOutlet UITextField *textfieldPosition;
@property (nonatomic, strong) IBOutlet UITextField *textfieldCity;

@property (nonatomic, strong) IBOutlet UILabel *lblAreaNumber;

@property (nonatomic, weak) IBOutlet UILabel *lblTip;

// 标题label
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblNick;
@property (nonatomic, strong) IBOutlet UILabel *lblEmail;
@property (nonatomic, strong) IBOutlet UILabel *lblCountry;
@property (nonatomic, strong) IBOutlet UILabel *lblPhone;
@property (nonatomic, strong) IBOutlet UILabel *lblCompany;
@property (nonatomic, strong) IBOutlet UILabel *lblDepartment;
@property (nonatomic, strong) IBOutlet UILabel *lblPosition;
@property (nonatomic, strong) IBOutlet UILabel *lblCity;

@property (nonatomic, strong) UserBaseInfo *baseInfo;

// 半透明遮罩
@property (nonatomic, strong) UIView *viewTranslucence_;

//
@property (nonatomic, strong) IBOutlet UIView *viewClaimPicker;
@property (nonatomic, strong) IBOutlet UIPickerView *claimPicker;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnCancel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnDone;

@property (nonatomic, strong) NSMutableArray *arrayCountry;
@property NSInteger indexCountry;

- (IBAction)showCountryAndArea;

- (IBAction)cancelPopViewForClaim;
- (IBAction)donePopViewForClaim;

@end

@implementation UserModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navView.lblTitle.text = @"基本资料";
    
    NSString *strValue = locatizedString(@"base_info");
    self.navView.lblTitle.text = strValue;
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    if (self.registerFlag == YES)
    {
        strValue = locatizedString(@"cancel");
        
        [self.navView.btnBack setImage:nil forState:UIControlStateNormal];
        [self.navView.btnBack setTitle:strValue forState:UIControlStateNormal];
        [self.navView.btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.navView.btnBack setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.navView.btnBack.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        self.lblTip.hidden = NO;
    }
    else
    {
        self.lblTip.hidden = YES;
    }
    
    strValue = locatizedString(@"save");
    
    // 确定
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:strValue forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)236/255 blue:(CGFloat)236/255 alpha:1];
    
    [self initView];
    
    [self initData];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHeader;
    
    self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, 521);
    self.viewBg.backgroundColor = [UIColor whiteColor];
    
    self.viewBg.layer.masksToBounds = YES;
    self.viewBg.layer.cornerRadius = 6;
    self.viewBg.layer.borderColor = [UIColor colorWithRed:(CGFloat)224/255 green:(CGFloat)224/255 blue:(CGFloat)224/255 alpha:1].CGColor;
    self.viewBg.layer.borderWidth = 1;
        
    self.viewTranslucence_ = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    self.viewTranslucence_.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer *tapGesture_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopViewForClaim)];
    [self.viewTranslucence_ addGestureRecognizer:tapGesture_];
    
    CGRect myRect = self.viewClaimPicker.bounds;
    myRect.origin.x = 0;
    myRect.origin.y = CGRectGetHeight(self.viewTranslucence_.frame) - myRect.size.height;
    self.viewClaimPicker.frame = CGRectMake(myRect.origin.x, myRect.origin.y, kScreenWidth, myRect.size.height);
    [self.viewTranslucence_ addSubview:self.viewClaimPicker];
    
    self.claimPicker.delegate = self;
    self.claimPicker.dataSource = self;
    [self.claimPicker reloadAllComponents];
    
    // 显示已完善的信息
    UserManager *userManager = [UserManager sharedInstance];
    if (userManager.userInfo.realname != nil && userManager.userInfo.realname.length > 0)
    {
        self.textfieldName.text = userManager.userInfo.realname;
    }
    if (userManager.userInfo.nickname != nil && userManager.userInfo.nickname.length > 0)
    {
        self.textfieldNickname.text = userManager.userInfo.nickname;
    }
    if (userManager.userInfo.email != nil && userManager.userInfo.email.length > 0)
    {
        self.textfieldEmail.text = userManager.userInfo.email;
    }
    if (userManager.userInfo.phone != nil && userManager.userInfo.phone.length > 0)
    {
        //self.textfieldPhone.text = userManager.userInfo.phone;
        
        NSString *strPhone = userManager.userInfo.phone;
        NSArray *arrayPhone = [strPhone componentsSeparatedByString:@" "];
        if (arrayPhone.count == 2)
        {
            NSString *phone = arrayPhone[1];
            if (phone != nil && phone.length > 0)
            {
                self.textfieldPhone.text = phone;
                
                NSString *area = arrayPhone[0];
                if ([area isEqualToString:@"+86"] == YES)
                {
                    self.textfieldCountry.text = self.arrayCountry[0];
                    self.lblAreaNumber.text = @"+86";
                    self.indexCountry = 0;
                }
                else if ([area isEqualToString:@"+852"] == YES)
                {
                    self.textfieldCountry.text = self.arrayCountry[1];
                    self.lblAreaNumber.text = @"+852";
                    self.indexCountry = 1;
                }
                else if ([area isEqualToString:@"+853"] == YES)
                {
                    self.textfieldCountry.text = self.arrayCountry[2];
                    self.lblAreaNumber.text = @"+853";
                    self.indexCountry = 2;
                }
            }
            else
            {
                self.textfieldPhone.text = strPhone;
            }
        }
        else
        {
            self.textfieldPhone.text = strPhone;
        }
    }
    if (userManager.userInfo.company != nil && userManager.userInfo.company.length > 0)
    {
        self.textfieldCompany.text = userManager.userInfo.company;
    }
    if (userManager.userInfo.department != nil && userManager.userInfo.department.length > 0)
    {
        self.textfieldDepartment.text = userManager.userInfo.department;
    }
    if (userManager.userInfo.zhiwei != nil && userManager.userInfo.zhiwei.length > 0)
    {
        self.textfieldPosition.text = userManager.userInfo.zhiwei;
    }
    if (userManager.userInfo.city != nil && userManager.userInfo.city.length > 0)
    {
        self.textfieldCity.text = userManager.userInfo.city;
    }
    
    self.textfieldName.returnKeyType = UIReturnKeyNext;
    self.textfieldNickname.returnKeyType = UIReturnKeyNext;
    self.textfieldEmail.returnKeyType = UIReturnKeyNext;
    self.textfieldCountry.returnKeyType = UIReturnKeyNext;
    self.textfieldPhone.returnKeyType = UIReturnKeyNext;
    self.textfieldCompany.returnKeyType = UIReturnKeyNext;
    self.textfieldDepartment.returnKeyType = UIReturnKeyNext;
    self.textfieldPosition.returnKeyType = UIReturnKeyNext;
    self.textfieldCity.returnKeyType = UIReturnKeyDone;
}

- (void)initData
{
    self.baseInfo = [[UserBaseInfo alloc] init];
    
    //self.arrayCountry = [NSMutableArray arrayWithObjects:@"China Mainland", @"HongKong", @"Macao", nil];
    
    self.indexCountry = 0;
}

- (NSMutableArray *)arrayCountry
{
    if (_arrayCountry == nil)
    {
        _arrayCountry = [NSMutableArray arrayWithObjects:@"China Mainland", @"HongKong", @"Macao", nil];
    }
    
    return _arrayCountry;
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
            case 1: {
                //[self toast:@"姓名不能为空"];
                NSString *strTip = locatizedString(@"name_nil");
                [self toast:strTip];
                break;
            }
            case 2: {
                //[self toast:@"昵称不能为空"];
                NSString *strTip = locatizedString(@"nickname_nil");
                [self toast:strTip];
                break;
            }
            case 3: {
                //[self toast:@"邮箱不能为空"];
                NSString *strTip = locatizedString(@"email_nil");
                [self toast:strTip];
                break;
            }
            case 4: {
                //[self toast:@"手机号不能为空"];
                NSString *strTip = locatizedString(@"phone_nil");
                [self toast:strTip];
                break;
            }
            case 5: {
                //[self toast:@"公司不能为空"];
                NSString *strTip = locatizedString(@"company_nil");
                [self toast:strTip];
                break;
            }
            case 6: {
                //[self toast:@"部门不能为空"];
                NSString *strTip = locatizedString(@"department_nil");
                [self toast:strTip];
                break;
            }
            case 7: {
                //[self toast:@"职位不能为空"];
                NSString *strTip = locatizedString(@"position_nil");
                [self toast:strTip];
                break;
            }
            case 8: {
                //[self toast:@"姓名长度非法"];
                NSString *strTip = locatizedString(@"name_length_invalid");
                [self toast:strTip];
                break;
            }
            case 9: {
                //[self toast:@"昵称长度非法"];
                NSString *strTip = locatizedString(@"nickname_length_invalid");
                [self toast:strTip];
                break;
            }
            case 10: {
                //[self toast:@"邮箱格式非法"];
                NSString *strTip = locatizedString(@"email_invalid");
                [self toast:strTip];
                break;
            }
            case 11: {
                //[self toast:@"手机号长度非法"];
                NSString *strTip = locatizedString(@"phone_length_invalid");
                [self toast:strTip];
                break;
            }
            case 12: {
                //[self toast:@"公司名称长度非法"];
                NSString *strTip = locatizedString(@"company_length_invalid");
                [self toast:strTip];
                break;
            }
            case 13: {
                //[self toast:@"部门名称长度非法"];
                NSString *strTip = locatizedString(@"department_length_invalid");
                [self toast:strTip];
                break;
            }
            case 14: {
                //[self toast:@"职位名称长度非法"];
                NSString *strTip = locatizedString(@"position_length_invalid");
                [self toast:strTip];
                break;
            }
            case 15: {
                //[self toast:@"城市名称长度非法"];
                NSString *strTip = locatizedString(@"city_length_invalid");
                [self toast:strTip];
                break;
            }
            case 16: {
                //[self toast:@"国家/区域不能为空"];
                NSString *strTip = locatizedString(@"country_nil");
                [self toast:strTip];
                break;
            }
            default:
                break;
        }
        
        return;
    }
    
    [self hideKeyboard];
    
    // 提交信息
    [self sumbitUserInfo];
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
    NSString *strValue = locatizedString(@"input_name");
    [self.textfieldName setPlaceholder:strValue];
 
    strValue = locatizedString(@"input_nickname");
    [self.textfieldNickname setPlaceholder:strValue];
    
    strValue = locatizedString(@"input_email");
    [self.textfieldEmail setPlaceholder:strValue];
    
    strValue = locatizedString(@"input_region");
    [self.textfieldCountry setPlaceholder:strValue];
    
    strValue = locatizedString(@"input_phone");
    [self.textfieldPhone setPlaceholder:strValue];
    
    strValue = locatizedString(@"input_company");
    [self.textfieldCompany setPlaceholder:strValue];
    
    strValue = locatizedString(@"input_department");
    [self.textfieldDepartment setPlaceholder:strValue];
    
    strValue = locatizedString(@"input_position");
    [self.textfieldPosition setPlaceholder:strValue];
    
    strValue = locatizedString(@"input_city");
    [self.textfieldCity setPlaceholder:strValue];
    
    /************************************************/
    
    strValue = locatizedString(@"realname_");
    self.lblName.text = [NSString stringWithFormat:@"%@:", strValue];
    
    strValue = locatizedString(@"nickname_");
    self.lblNick.text = [NSString stringWithFormat:@"%@:", strValue];
    
    strValue = locatizedString(@"email_");
    self.lblEmail.text = [NSString stringWithFormat:@"%@:", strValue];
    
    strValue = locatizedString(@"country/region");
    self.lblCountry.text = [NSString stringWithFormat:@"%@:", strValue];
    
    strValue = locatizedString(@"phone_");
    self.lblPhone.text = [NSString stringWithFormat:@"%@:", strValue];
    
    strValue = locatizedString(@"company_");
    self.lblCompany.text = [NSString stringWithFormat:@"%@:", strValue];
    
    strValue = locatizedString(@"department_");
    self.lblDepartment.text = [NSString stringWithFormat:@"%@:", strValue];
    
    strValue = locatizedString(@"position_");
    self.lblPosition.text = [NSString stringWithFormat:@"%@:", strValue];
    
    strValue = locatizedString(@"city_");
    self.lblCity.text = [NSString stringWithFormat:@"%@:", strValue];
    
    strValue = locatizedString(@"user_info_complete");
    self.lblTip.text = strValue;
    
    /************************************************/
    
    strValue = locatizedString(@"cancel");
    [self.barbtnCancel setTitle:strValue];
    
    strValue = locatizedString(@"done");
    [self.barbtnDone setTitle:strValue];
}


#pragma mark - Custom

// 0-合法 1-姓名为空 2-昵称为空 3-邮箱为空 4-电话为空 5-公司为空 6-部门为空 7-职位为空 8-姓名长度非法 9-昵称长度非法 10-邮箱格式非法 11-电话长度非法 12-公司长度非法 13-部门长度非法 14-职位长度非法 15-城市长度非法
- (int)checkContent
{
    if ([NSString checkContent:self.textfieldName.text] == NO)
    {
        return 1;
    }
    
    if ([NSString checkContent:self.textfieldNickname.text] == NO)
    {
        return 2;
    }
    
    if ([NSString checkContent:self.textfieldEmail.text] == NO)
    {
        return 3;
    }
    
    if ([NSString checkContent:self.textfieldPhone.text] == NO)
    {
        return 4;
    }
    
    if ([NSString checkContent:self.textfieldCompany.text] == NO)
    {
        return 5;
    }
    
    if ([NSString checkContent:self.textfieldDepartment.text] == NO)
    {
        return 6;
    }
    
    if ([NSString checkContent:self.textfieldPosition.text] == NO)
    {
        return 7;
    }
    
    // Add Country
    if ([NSString checkContent:self.textfieldCountry.text] == NO)
    {
        return 16;
    }
    
    /**************************************************************/
    
    if (self.textfieldName.text.length > 20 && self.textfieldName.text.length < 2)
    {
        return 8;
    }
    
    if (self.textfieldNickname.text.length > 20 && self.textfieldNickname.text.length < 2)
    {
        return 9;
    }

    if ([NSString checkMailAddress:self.textfieldEmail.text] == NO)
    {
        return 10;
    }
    
    if (self.textfieldPhone.text.length > 12 && self.textfieldPhone.text.length < 8)
    {
        return 11;
    }
    
    if (self.textfieldCompany.text.length > 88 && self.textfieldCompany.text.length < 2)
    {
        return 12;
    }
    
    if (self.textfieldDepartment.text.length > 88 && self.textfieldDepartment.text.length < 2)
    {
        return 13;
    }
    
    if (self.textfieldPosition.text.length > 20 && self.textfieldPosition.text.length < 2)
    {
        return 14;
    }
    
    if ([NSString checkContent:self.textfieldCity.text] == YES && self.textfieldCity.text.length > 28 && self.textfieldCity.text.length < 2)
    {
        return 15;
    }
    
    
    return 0;
}


#pragma mark - Request

- (void)sumbitUserInfo
{
    self.baseInfo.realname = [self.textfieldName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.baseInfo.nickname = [self.textfieldNickname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.baseInfo.email = [self.textfieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //self.baseInfo.phone = [self.textfieldPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strPhone = [self.textfieldPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.baseInfo.phone = [NSString stringWithFormat:@"%@ %@", self.lblAreaNumber.text, strPhone];
    self.baseInfo.company = [self.textfieldCompany.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.baseInfo.department = [self.textfieldDepartment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.baseInfo.position = [self.textfieldPosition.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.baseInfo.city = [self.textfieldCity.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager submitUserBaseInfo:self.baseInfo completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                /*
                {
                    "data": {
                        "bossstatus": 0,
                        "city": "武汉",
                        "company": "酷控科技",
                        "createtime": "2015/09/11 12:33:01",
                        "department": "无线研发部",
                        "email": "110381582@qq.com",
                        "id": 54,
                        "img": "http://115.29.105.23:8080/img/user/BQEDCJOHTP.png",
                        "name": "terry",
                        "nickname": "Terry",
                        "open_id": null,
                        "phone": "18507103285",
                        "pwd": "d93a5def7511da3d0f2d171d9c344e91",
                        "realname": "夏志勇",
                        "type": 1,
                        "zhiwei": "经理"
                    },
                    "message": "更新成功",
                    "status": 1,
                    "total": 0
                }
                */
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"提交成功");
                    
                    UserInfoModel *userInfo = response.data;
                    NSLog(@"data:%@", userInfo);
                    
                    // 更新
                    UserManager *userManager = [UserManager sharedInstance];
                    //userManager.userInfo = userInfo;
                    userManager.userInfo.realname = userInfo.realname;
                    userManager.userInfo.nickname = userInfo.nickname;
                    userManager.userInfo.email = userInfo.email;
                    userManager.userInfo.phone = userInfo.phone;
                    userManager.userInfo.company = userInfo.company;
                    userManager.userInfo.department = userInfo.department;
                    userManager.userInfo.zhiwei = userInfo.zhiwei;
                    userManager.userInfo.city = userInfo.city;
                    
                    //[self toast:@"提交成功"];
                    NSString *strTip = locatizedString(@"submit_success");
                    [self toast:strTip];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserInfo object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    NSLog(@"提交失败");
                    //[self toast:@"提交失败"];
                    
                    NSString *strTip = locatizedString(@"submit_fail");
                    [self toast:strTip];
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
                //[self toast:@"提交失败"];
                
                NSString *strTip = locatizedString(@"submit_fail");
                [self toast:strTip];
            }
        }
        
    }];
}


#pragma mark - BtnTouchAction

- (IBAction)showCountryAndArea
{
    [self hideKeyboard];
    
    [self.claimPicker selectRow:0 inComponent:0 animated:YES];
    [self.view addSubview:self.viewTranslucence_];
}


#pragma mark -

- (void)hidePopViewForClaim
{
    [self.viewTranslucence_ removeFromSuperview];
}

- (IBAction)cancelPopViewForClaim
{
    [self hidePopViewForClaim];
}

- (IBAction)donePopViewForClaim
{
    NSInteger index = [self.claimPicker selectedRowInComponent:0];
    self.indexCountry = index;
    self.textfieldCountry.text = self.arrayCountry[index];
    
    if (self.indexCountry == 0)
    {
        self.lblAreaNumber.text = @"+86";
    }
    else if (self.indexCountry == 1)
    {
        self.lblAreaNumber.text = @"+852";
    }
    else if (self.indexCountry == 2)
    {
        self.lblAreaNumber.text = @"+853";
    }
    
    [self hidePopViewForClaim];
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


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textfieldName)
    {
        [self.textfieldName resignFirstResponder];
        [self.textfieldNickname becomeFirstResponder];
    }
    else if (textField == self.textfieldNickname)
    {
        [self.textfieldNickname resignFirstResponder];
        [self.textfieldEmail becomeFirstResponder];
    }
    else if (textField == self.textfieldEmail)
    {
        [self.textfieldEmail resignFirstResponder];
        [self.textfieldPhone becomeFirstResponder];
    }
//    else if (textField == self.textfieldCountry)
//    {
//        [self.textfieldCountry resignFirstResponder];
//        [self.textfieldPhone becomeFirstResponder];
//    }
    else if (textField == self.textfieldPhone)
    {
        [self.textfieldPhone resignFirstResponder];
        [self.textfieldCompany becomeFirstResponder];
    }
    else if (textField == self.textfieldCompany)
    {
        [self.textfieldCompany resignFirstResponder];
        [self.textfieldDepartment becomeFirstResponder];
    }
    else if (textField == self.textfieldDepartment)
    {
        [self.textfieldDepartment resignFirstResponder];
        [self.textfieldPosition becomeFirstResponder];
    }
    else if (textField == self.textfieldPosition)
    {
        [self.textfieldPosition resignFirstResponder];
        [self.textfieldCity becomeFirstResponder];
    }
    else if (textField == self.textfieldCity)
    {
        [self.textfieldCity resignFirstResponder];
        
        // save
        [self moreAction];
    }
    
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
    return self.arrayCountry.count;
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
    return self.arrayCountry[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //
}


@end
