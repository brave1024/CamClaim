//
//  ChangePasswordViewController.m
//  CamClaim
//
//  Created by 夏志勇 on 15/9/17.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *viewTableHeader;
@property (nonatomic, strong) IBOutlet UIView *viewBg;
@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) IBOutlet UITextField *textfieldPswOld;
@property (nonatomic, strong) IBOutlet UITextField *textfieldPswNew;
@property (nonatomic, strong) IBOutlet UITextField *textfieldPswAgain;

@property (nonatomic, strong) UserBaseInfo *baseInfo;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"Change Password";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    // 保存
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:@"保存" forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHeader;
    
    self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, 194);
    self.viewBg.backgroundColor = [UIColor whiteColor];
    
    self.viewBg.layer.masksToBounds = YES;
    self.viewBg.layer.cornerRadius = 6;
    self.viewBg.layer.borderColor = [UIColor colorWithRed:(CGFloat)224/255 green:(CGFloat)224/255 blue:(CGFloat)224/255 alpha:1].CGColor;
    self.viewBg.layer.borderWidth = 1;
    
    self.textfieldPswOld.returnKeyType = UIReturnKeyNext;
    self.textfieldPswNew.returnKeyType = UIReturnKeyNext;
    self.textfieldPswAgain.returnKeyType = UIReturnKeyDone;
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
                [self toast:@"旧密码不能为空"];
                break;
            case 2:
                [self toast:@"新密码不能为空"];
                break;
            case 3:
                [self toast:@"重复密码不能为空"];
                break;
            case 4:
                [self toast:@"旧密码长度非法"];
                break;
            case 5:
                [self toast:@"新密码长度非法"];
                break;
            case 6:
                [self toast:@"重复密码长度非法"];
                break;
            case 7:
                [self toast:@"新密码不一致"];
                break;
            case 8:
                [self toast:@"旧密码输入错误"];
                break;
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
    
    
}



#pragma mark - Custom

// 0-合法 1-旧密码为空 2-新密码为空 3-重复密码为空 4-旧密码长度非法 5-新密码长度非法 6-重复密码长度非法 7-新密码不一致 8-旧密码输入错误
- (int)checkContent
{
    if ([NSString checkContent:self.textfieldPswOld.text] == NO)
    {
        return 1;
    }
    
    if ([NSString checkContent:self.textfieldPswNew.text] == NO)
    {
        return 2;
    }
    
    if ([NSString checkContent:self.textfieldPswAgain.text] == NO)
    {
        return 3;
    }
    
    /**************************************************************/
    
    if (self.textfieldPswOld.text.length > 20 && self.textfieldPswOld.text.length < 6)
    {
        return 4;
    }
    
    if (self.textfieldPswNew.text.length > 20 && self.textfieldPswNew.text.length < 6)
    {
        return 5;
    }
    
    if (self.textfieldPswAgain.text.length > 20 && self.textfieldPswAgain.text.length < 6)
    {
        return 6;
    }
    
    if ([self.textfieldPswNew.text isEqualToString:self.textfieldPswAgain.text] == NO)
    {
        return 7;
    }
    
    // 判断新密码是否输入正确
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *strPswOld = [userDef valueForKey:kPassword];
    if ([strPswOld isEqualToString:self.textfieldPswOld.text] == NO)
    {
        return 8;
    }
    
    return 0;
}


#pragma mark - Request

- (void)sumbitUserInfo
{
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager changeUserPassword:self.textfieldPswNew.text completion:^(BOOL isSucceed, NSString *message, id data) {
        
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
                    
                    UserInfoModel *userInfo = response.data;
                    NSLog(@"data:%@", userInfo);
                    
                    // 更新
                    UserManager *userManager = [UserManager sharedInstance];
                    //userManager.userInfo = userInfo;
                    userManager.userInfo.pwd = userInfo.pwd;
                    
                    // 保存新密码
                    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                    [userDef setValue:self.textfieldPswNew.text forKey:kPassword];
                    [userDef setBool:YES forKey:kLoginType];    // 手动登录
                    [userDef synchronize];
                    
                    [self toast:@"提交成功"];
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
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"settingCell";
//    SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil)
//    {
//        cell = [SettingCell cellFromNib];
//    }
//    
//    NSDictionary *dic = self.arrayList[indexPath.row];
//    [cell configWithData:dic];
//    
//    cell.backgroundColor = [UIColor whiteColor];
//    cell.contentView.backgroundColor = [UIColor whiteColor];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    return cell;
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSDictionary *dic = self.arrayList[indexPath.row];
//    NSString *strSelector = dic[@"selectorForJump"];
//    if (strSelector != nil && strSelector.length > 0)
//    {
//        //SEL selector = NSSelectorFromString(strSelector);
//        //[self performSelector:selector withObject:nil];
//        
//        // 消除警告: iOS PerformSelector may cause a leak because its selector is unknown
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [self performSelector:NSSelectorFromString(strSelector) withObject:nil];
//#pragma clang diagnostic pop
//    }
//    else
//    {
//        //
//    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textfieldPswOld)
    {
        [self.textfieldPswOld resignFirstResponder];
        [self.textfieldPswNew becomeFirstResponder];
    }
    else if (textField == self.textfieldPswNew)
    {
        [self.textfieldPswNew resignFirstResponder];
        [self.textfieldPswAgain becomeFirstResponder];
    }
    else if (textField == self.textfieldPswAgain)
    {
        [self.textfieldPswAgain resignFirstResponder];
    }
    
    return YES;
}


@end
