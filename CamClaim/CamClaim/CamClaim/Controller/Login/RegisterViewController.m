//
//  RegisterViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/4.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () <NavViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollview;
@property (nonatomic, weak) IBOutlet UITextField *textfieldEmail;
@property (nonatomic, weak) IBOutlet UITextField *textfieldName;
@property (nonatomic, weak) IBOutlet UITextField *textfieldPhone;
@property (nonatomic, weak) IBOutlet UITextField *textfieldPassword;

@property (nonatomic, weak) IBOutlet UIButton *btnRegister;

// bg
@property (nonatomic, weak) IBOutlet UIImageView *imgviewEmail;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewName;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewPhone;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewPassword;

- (IBAction)registerAction;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"Register";
    
    UIImage *img = [UIImage imageNamed:@"img_input"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    self.imgviewEmail.image = img;
    self.imgviewName.image = img;
    self.imgviewPhone.image = img;
    self.imgviewPassword.image = img;
    
//    UIImage *img_ = [UIImage imageNamed:@"img_input_press"];
//    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    UIImage *imgBtn = [UIImage imageNamed:@"btn_register"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    UIImage *imgBtn_ = [UIImage imageNamed:@"btn_register_press"];
    imgBtn_ = [imgBtn_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    [self.btnRegister setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [self.btnRegister setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    
    [self.btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnRegister setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    self.textfieldEmail.returnKeyType = UIReturnKeyNext;
    self.textfieldName.returnKeyType = UIReturnKeyNext;
    self.textfieldPassword.returnKeyType = UIReturnKeyDone;
    
    // TEST
    //[self.btnRegister setTitleColor:[UIColor colorWithRed:(CGFloat)18/255 green:(CGFloat)82/255 blue:(CGFloat)168/255 alpha:1] forState:UIControlStateNormal];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 用于在界面左侧做右滑手抛时pop当前视图...
    if (__CUR_IOS_VERSION >= __IPHONE_7_0)
    {
        // 用于在界面左侧做右滑手抛时pop当前视图...
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 用于在界面左侧做右滑手抛时pop当前视图...
    if (__CUR_IOS_VERSION >= __IPHONE_7_0)
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
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


#pragma mark - AutoLayout

- (void)initViewWithAutoLayout
{
    self.scrollviewWidth.constant = kScreenWidth;
    self.viewBarWidth.constant = kScreenWidth - 10*2;
    self.viewBarWidth_1.constant = kScreenWidth - 10*2;
    self.viewBarWidth_2.constant = kScreenWidth - 10*2;
    self.viewBarWidth_3.constant = kScreenWidth - 10*2;
    self.btnRegisterWidth.constant = kScreenWidth - 20*2;
    
    if (kScreenWidth == kWidthFor5)
    {
        self.txtfieldWidth.constant = 190;
        self.txtfieldWidth_1.constant = 190;
        self.txtfieldWidth_2.constant = 190;
        self.txtfieldWidth_3.constant = 190;
    }
    else if (kScreenWidth == kWidthFor6)
    {
        self.txtfieldWidth.constant = 375-70*2 + 4;
        self.txtfieldWidth_1.constant = 375-70*2 + 4;
        self.txtfieldWidth_2.constant = 375-70*2 + 4;
        self.txtfieldWidth_3.constant = 375-70*2 + 4;
    }
    else if (kScreenWidth == kWidthFor6plus)
    {
        self.txtfieldWidth.constant = 414-70*2 + 4;
        self.txtfieldWidth_1.constant = 414-70*2 + 4;
        self.txtfieldWidth_2.constant = 414-70*2 + 4;
        self.txtfieldWidth_3.constant = 414-70*2 + 4;
    }
}


#pragma mark - Language

- (void)settingLanguage
{
    NSString *strValue = locatizedString(@"email");
    [self.textfieldEmail setPlaceholder:strValue];
    
    strValue = locatizedString(@"password");
    [self.textfieldPassword setPlaceholder:strValue];
    
    strValue = locatizedString(@"realName");
    [self.textfieldName setPlaceholder:strValue];
    
    strValue = locatizedString(@"phone");
    [self.textfieldPhone setPlaceholder:strValue];
    
    strValue = locatizedString(@"register");
    [self.btnRegister setTitle:strValue forState:UIControlStateNormal];
    
    self.navView.lblTitle.text = strValue;
}


#pragma mark - NavViewDelegate

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - BtnAction

- (IBAction)registerAction
{
    [self hideKeyboard];
    
    int status = [self checkContent];
    if (status != 0)
    {
        switch (status) {
            case 1:
                [self toast:@"账号不能为空"];
                break;
            case 2:
                [self toast:@"密码不能为空"];
                break;
            case 3:
                [self toast:@"账号长度非法"];
                break;
            case 4:
                [self toast:@"密码长度非法"];
                break;
            case 5:
                [self toast:@"账号格式非法"];
                break;
            case 6:
                [self toast:@"密码格式非法"];
                break;
            case 7:
                [self toast:@"姓名不能为空"];
                break;
            case 8:
                [self toast:@"手机号不能为空"];
                break;
            case 9:
                [self toast:@"姓名长度非法"];
                break;
            case 10:
                [self toast:@"手机号长度非法"];
                break;
            default:
                break;
        }
        
        return;
    }
    
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager userRegister:self.textfieldEmail.text password:self.textfieldPassword.text name:self.textfieldName.text phone:self.textfieldPhone.text completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                // {"status":1,"message":"保存成功","data":null,"total":0}
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"注册成功");
                    [self toast:@"注册成功,请登录"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    NSLog(@"注册失败");
                    [self toast:@"注册失败"];
                }
            }
            else
            {
                NSLog(@"注册失败");
                [self toast:@"注册失败"];
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
                [self toast:@"注册失败"];
            }
        }
        
    }];
}


#pragma mark -

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

// 0-合法 1-账号为空 2-密码为空 3-账号长度非法 4-密码长度非法 5-账号格式非法 6-密码格式非法
// 7-姓名为空 8-手机号为空 9-姓名长度非法 10-手机号长度非法
- (int)checkContent
{
    if ([NSString checkContent:self.textfieldEmail.text] == NO)
    {
        return 1;
    }
    
    if ([NSString checkContent:self.textfieldPassword.text] == NO)
    {
        return 2;
    }
    
    if ([NSString checkContent:self.textfieldName.text] == NO)
    {
        return 7;
    }
    
    if ([NSString checkContent:self.textfieldPhone.text] == NO)
    {
        return 8;
    }
    
    if (self.textfieldEmail.text.length > 18 && self.textfieldEmail.text.length < 4)
    {
        return 3;
    }
    
    if (self.textfieldPassword.text.length > 18 && self.textfieldPassword.text.length < 4)
    {
        return 4;
    }
    
    if (self.textfieldName.text.length > 28 && self.textfieldName.text.length < 2)
    {
        return 9;
    }
    
    if (self.textfieldPhone.text.length < 11)
    {
        return 10;
    }
    
    return 0;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textfieldEmail)
    {
        [textField resignFirstResponder];
        [self.textfieldName becomeFirstResponder];
    }
    else if (textField == self.textfieldName)
    {
        [textField resignFirstResponder];
        [self.textfieldPhone becomeFirstResponder];
    }
    else if (textField == self.textfieldPassword)
    {
        [self.textfieldPassword resignFirstResponder];
    }
    
    return YES;
}


@end