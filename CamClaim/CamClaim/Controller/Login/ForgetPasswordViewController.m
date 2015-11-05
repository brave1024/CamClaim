//
//  ForgetPasswordViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/19.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *viewTableHeader;
@property (nonatomic, strong) IBOutlet UIView *viewBg;
@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) IBOutlet UITextField *textfieldEmail;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navView.lblTitle.text = @"忘记密码";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    NSString *strValue = locatizedString(@"sumbit");
    
    // 提交
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:strValue forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)236/255 blue:(CGFloat)236/255 alpha:1];
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHeader;
    
    self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, 95);
    self.viewBg.backgroundColor = [UIColor whiteColor];
    
    self.viewBg.layer.masksToBounds = YES;
    self.viewBg.layer.cornerRadius = 6;
    self.viewBg.layer.borderColor = [UIColor colorWithRed:(CGFloat)224/255 green:(CGFloat)224/255 blue:(CGFloat)224/255 alpha:1].CGColor;
    self.viewBg.layer.borderWidth = 1;
    
    self.textfieldEmail.returnKeyType = UIReturnKeyDone;
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
                //[self toast:@"邮箱不能为空"];
                NSString *strTip = locatizedString(@"email_nil");
                [self toast:strTip];
                break;
            }
            case 2: {
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
    
    [self hideKeyboard];
    
    // 提交信息
    [self sumbitUserEmail];
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
    NSString *strValue = locatizedString(@"input_email_register");
    [self.textfieldEmail setPlaceholder:strValue];
    
    strValue = locatizedString(@"forget_password_for_title");
    self.navView.lblTitle.text = strValue;
}


#pragma mark - Custom

// 0-合法 1-邮箱为空 2-邮箱地址非法
- (int)checkContent
{
    if ([NSString checkContent:self.textfieldEmail.text] == NO)
    {
        return 1;
    }
    
    if ([NSString checkMailAddress:self.textfieldEmail.text] == NO)
    {
        return 2;
    }

    return 0;
}


#pragma mark - Request

- (void)sumbitUserEmail
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
    [textField resignFirstResponder];
    return YES;
}


@end
