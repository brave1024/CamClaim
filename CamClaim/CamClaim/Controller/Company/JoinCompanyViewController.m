//
//  JoinCompanyViewController.m
//  CamClaim
//
//  Created by 夏志勇 on 15/10/21.
//  Copyright © 2015年 kufa88. All rights reserved.
//

#import "JoinCompanyViewController.h"

@interface JoinCompanyViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UIView *viewTableHead;

@property (nonatomic, strong) IBOutlet UITextField *txtfieldName;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldPhone;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldEmail;

@property (nonatomic, strong) IBOutlet UITextField *txtfieldCompany;

@property (nonatomic, strong) IBOutlet UILabel *lblUser;
@property (nonatomic, strong) IBOutlet UILabel *lblCompany;

@end

@implementation JoinCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navView.lblTitle.text = @"Join Company";
    
    NSString *strValue = locatizedString(@"join company");
    self.navView.lblTitle.text = strValue;
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    strValue = locatizedString(@"sumbit");
    
    // 加入 confirm
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:strValue forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self initData];
    
    [self settingLanguage];
}

- (void)initView
{
    self.viewTableHead.frame = CGRectMake(0, 0, kScreenWidth, 306);
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHead;
    
    [self.tableview reloadData];
    
    self.txtfieldName.returnKeyType = UIReturnKeyNext;
    self.txtfieldPhone.returnKeyType = UIReturnKeyNext;
    self.txtfieldEmail.returnKeyType = UIReturnKeyDone;
}

- (void)initData
{
    self.txtfieldCompany.text = nil;
    self.txtfieldCompany.text = self.company.companyinfo;
    
    // 若用户资料完备，则自动填充
    UserManager *userManager = [UserManager sharedInstance];
    UserInfoModel *userInfo = userManager.userInfo;
    if (userInfo.realname != nil && userInfo.realname.length > 0)
    {
        self.txtfieldName.text = userInfo.realname;
    }
    if (userInfo.phone != nil && userInfo.phone.length > 0)
    {
        self.txtfieldPhone.text = userInfo.phone;
    }
    if (userInfo.email != nil && userInfo.email.length > 0)
    {
        self.txtfieldEmail.text = userInfo.email;
    }
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

// 加入
- (void)moreAction
{
    [self hideKeyboard];
    
    int status = [self checkUserContent];
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
                //[self toast:@"手机号不能为空"];
                NSString *strTip = locatizedString(@"phone_nil");
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
                //[self toast:@"邮箱格式错误"];
                NSString *strTip = locatizedString(@"email_invalid");
                [self toast:strTip];
                break;
            }
            case 5: {
                //[self toast:@"手机长度非法"];
                NSString *strTip = locatizedString(@"phone_length_invalid");
                [self toast:strTip];
                break;
            }
            default:
                break;
        }
        
        return;
    }
    
    [self requestForJoinCompany];
}


#pragma mark - AutoLayout

- (void)initViewWithAutoLayout
{
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
    NSString *strValue = locatizedString(@"company_userinfo");
    self.lblUser.text = strValue;
    
    strValue = locatizedString(@"company_user_join");
    self.lblCompany.text = strValue;
    
    strValue = locatizedString(@"name");
    [self.txtfieldName setPlaceholder:strValue];
    
    strValue = locatizedString(@"phone");
    [self.txtfieldPhone setPlaceholder:strValue];
    
    strValue = locatizedString(@"email");
    [self.txtfieldEmail setPlaceholder:strValue];
}


#pragma mark - Custom

// 0-ok 1-姓名不能为空 2-手机号不能为空 3-邮箱不能为空 4-邮箱格式非法 5-手机长度非法
- (int)checkUserContent
{
    if ([NSString checkContent:self.txtfieldName.text] == NO)
    {
        return 1;
    }
    
    if ([NSString checkContent:self.txtfieldPhone.text] == NO)
    {
        return 2;
    }
    
    if ([NSString checkContent:self.txtfieldEmail.text] == NO)
    {
        return 3;
    }
    
    if ([NSString checkMailAddress:self.txtfieldEmail.text] == NO)
    {
        return 4;
    }
    
//    if (self.txtfieldPhone.text.length < 8 || self.txtfieldPhone.text.length > 12)
//    {
//        return 5;
//    }
    
    return 0;
}


#pragma mark - HttpRequest

- (void)requestForJoinCompany
{
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager userJoinCompany:self.company.id withEmail:self.txtfieldEmail.text andphone:self.txtfieldPhone.text andUserNumber:self.txtfieldName.text completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                // {"status":1,"message":"joing公司成功","data":null,"total":0}
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"申请加入公司成功");
                    //[self toast:@"发送加入公司申请成功"];
                    
                    NSString *strTip = locatizedString(@"sumbitSuccess");
                    [self toast:strTip];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    NSLog(@"申请加入公司失败");
                    //[self toast:@"申请加入公司失败"];
                    
                    NSString *strTip = locatizedString(@"submitFail");
                    [self toast:strTip];
                }
            }
            else
            {
                // 无数据
                NSLog(@"申请加入公司失败");
                //[self toast:@"申请加入公司失败"];
                
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
                //[self toast:@"申请加入公司失败"];
                
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


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtfieldName)
    {
        [textField resignFirstResponder];
        [self.txtfieldPhone becomeFirstResponder];
    }
    else if (textField == self.txtfieldPhone)
    {
        [textField resignFirstResponder];
        [self.txtfieldEmail becomeFirstResponder];
    }
    else
    {
        [self.txtfieldEmail resignFirstResponder];
    }
    
    return YES;
}


@end
