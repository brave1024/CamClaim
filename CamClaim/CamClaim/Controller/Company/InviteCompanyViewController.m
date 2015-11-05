//
//  InviteCompanyViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/10/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "InviteCompanyViewController.h"
#import "CompanyActivityModel.h"

@interface InviteCompanyViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) IBOutlet UIView *viewTableHeader;
@property (nonatomic, strong) IBOutlet UILabel *lblTip;
@property (nonatomic, strong) IBOutlet UITextView *textviewTip;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldCompany;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldManager;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldEmail;
@property (nonatomic, strong) IBOutlet UILabel *lblCode;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblCompanyInfo;
@property (nonatomic, strong) IBOutlet UILabel *lblRule;
@property (nonatomic, strong) IBOutlet UITextView *textviewCodeTip;
@property (nonatomic, strong) IBOutlet UILabel *lblCodeTip;


@property (nonatomic, strong) CompanyActivityModel *activityItem;

@property (nonatomic, weak) IBOutlet UIWebView *webview;
@property (nonatomic, copy) NSString *stringUrl;

- (IBAction)submitInviteForCompany;

@end

@implementation InviteCompanyViewController

#define kUrl @"http://115.29.105.23:8080/sales/user/invitation"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navView.lblTitle.text = @"Join CamClaim";
    
    NSString *strValue = locatizedString(@"camclaim_join");
    self.navView.lblTitle.text = strValue;
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self initData];
    
    [self settingLanguage];
    
    [self requestInviteCompanyInfo];
}

- (void)initView
{
    self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, 610);
    self.viewTableHeader.backgroundColor = [UIColor clearColor];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHeader;
    [self.tableview reloadData];
    
    //
    UIImage *imgBtn = [UIImage imageNamed:@"new_btn_setting"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    
    [self.btnSubmit setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [self.btnSubmit setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.btnSubmit setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
    //self.textviewTip.text = @"1.邀请公司填写公司信息，发送代码到公司邮箱。\n2.公司通过审核，邀请人即刻获得奖励$1000。（7个工作日内）";
    
    self.txtfieldCompany.returnKeyType = UIReturnKeyNext;
    self.txtfieldManager.returnKeyType = UIReturnKeyNext;
    self.txtfieldEmail.returnKeyType = UIReturnKeyDone;
    
    self.lblTip.text = nil;
    self.textviewTip.text = nil;
    self.lblCode.text = nil;
    
    self.tableview.hidden = YES;
}

- (void)initData
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSLog(@"用户已登录");
        self.stringUrl = [NSString stringWithFormat:@"%@?userid=%@", kUrl, userId];
    }
    else
    {
        NSLog(@"用户未登录");
        self.stringUrl = kUrl;
    }
    
    // http://115.29.105.23:8080/sales/user/invitation?userid=22
    
    NSURL *url = [NSURL URLWithString:self.stringUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
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
    NSString *strValue = locatizedString(@"company_invite_title");
    self.lblTitle.text = strValue;
    
    strValue = locatizedString(@"company_invite_fill");
    self.lblCompanyInfo.text = strValue;
    
    strValue = locatizedString(@"company_invite_rule");
    self.lblRule.text = strValue;
    
    strValue = locatizedString(@"company_invite_code_tip");
    self.textviewCodeTip.text = strValue;
    
    strValue = locatizedString(@"company_invite_code");
    self.lblCodeTip.text = strValue;
    
    strValue = locatizedString(@"company_invite_submit");
    [self.btnSubmit setTitle:strValue forState:UIControlStateNormal];
    
    strValue = locatizedString(@"company_tip_invite_company");
    self.txtfieldCompany.placeholder = strValue;
    
    strValue = locatizedString(@"company_tip_invite_name");
    self.txtfieldManager.placeholder = strValue;
    
    strValue = locatizedString(@"company_tip_invite_email");
    self.txtfieldEmail.placeholder = strValue;
}


#pragma mark - Custom

- (IBAction)submitInviteForCompany
{
    [self hideKeyboard];
    
    int status = [self checkContent];
    if (status != 0)
    {
        switch (status) {
            case 1: {
                //[self toast:@"公司不能为空"];
                NSString *strTip = locatizedString(@"claim_company_nil");
                [self toast:strTip];
                break;
            }
            case 2: {
                //[self toast:@"姓名不能为空"];
                NSString *strTip = locatizedString(@"name_nil");
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
                //[self toast:@"邮箱格式非法"];
                NSString *strTip = locatizedString(@"email_invalid");
                [self toast:strTip];
                break;
            }
            default:
                break;
        }
        
        return;
    }
    
    [self sumbitInviteCompany];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

// 0-合法 1-公司为空 2-姓名为空 3-邮箱为空 6-邮箱格式非法
- (int)checkContent
{
    if ([NSString checkContent:self.txtfieldCompany.text] == NO)
    {
        return 1;
    }
    
    if ([NSString checkContent:self.txtfieldManager.text] == NO)
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
    
    return 0;
}


#pragma mark - Request

- (void)requestInviteCompanyInfo
{
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager getUserInviteCompanyInfo:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"获取邀请公司相关活动信息成功");
                    
                    self.activityItem = response.data;
                    NSLog(@"%@", self.activityItem);
                    
                    NSString *strContent = self.activityItem.activityttwo;
                    strContent = [strContent stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                    strContent = [strContent stringByReplacingOccurrencesOfString:@" " withString:@""];
                    self.activityItem.activityttwo = strContent;
                    
                    self.lblTip.text = self.activityItem.activitytone;
                    self.textviewTip.text = self.activityItem.activityttwo;
                    self.lblCode.text = self.activityItem.code;
                    
                    self.tableview.hidden = NO;
                    
                    if ([self.activityItem.flag intValue] == 1)
                    {
                        // 有效
                        self.viewTableHeader.userInteractionEnabled = YES;
                    }
                    else
                    {
                        // 2-无效
                        self.viewTableHeader.userInteractionEnabled = NO;
                        
                        NSString *strTip = locatizedString(@"company_invite_activity_time");
                        [self toast:strTip];
                    }
                }
                else
                {
                    NSLog(@"暂无消息记录");
                    //[self toast:@"暂无消息记录"];
                    
                    NSString *strTip = locatizedString(@"company_invite_get_fail");
                    [self toast:strTip];
                }
            }
            else
            {
                NSLog(@"暂无消息记录");
                //[self toast:@"暂无消息记录"];
                
                NSString *strTip = locatizedString(@"company_invite_get_fail");
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
                //[self toast:@"获取消息记录失败"];
                
                NSString *strTip = locatizedString(@"company_invite_get_fail");
                [self toast:strTip];
            }
        }
        
    }];
}

- (void)sumbitInviteCompany
{
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager userInviteCompany:self.txtfieldCompany.text withManager:self.txtfieldManager.text andManagerEmail:self.txtfieldEmail.text andCode:self.activityItem.code completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"获取邀请公司相关活动信息成功");
                    
                    NSString *strTip = locatizedString(@"sumbitSuccess");
                    [self toast:strTip];
                    
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
    //return self.arrayClaim.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtfieldCompany)
    {
        [self.txtfieldCompany resignFirstResponder];
        [self.txtfieldManager becomeFirstResponder];
    }
    else if (textField == self.txtfieldManager)
    {
        [self.txtfieldManager resignFirstResponder];
        [self.txtfieldEmail becomeFirstResponder];
    }
    else if (textField == self.txtfieldEmail)
    {
        [self.txtfieldEmail resignFirstResponder];
    }

    return YES;
}


@end
