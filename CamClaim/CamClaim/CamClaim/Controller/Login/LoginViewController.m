//
//  LoginViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/4.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "RTLabel.h"
#import <ShareSDK/ShareSDK.h>

#import "VVBaseModel.h"
#import "VVAPIClient.h"


@interface LoginViewController () <UIScrollViewDelegate, UITextFieldDelegate, RTLabelDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollview;
@property (nonatomic, weak) IBOutlet UITextField *textfieldAccount;
@property (nonatomic, weak) IBOutlet UITextField *textfieldPassword;
@property (nonatomic, weak) IBOutlet UIButton *btnRemember;
@property (nonatomic, weak) IBOutlet RTLabel *rtlblRegister;
@property (nonatomic, weak) IBOutlet UIButton *btnRegister;
@property (nonatomic, weak) IBOutlet UIButton *btnLogin;

// bg
@property (nonatomic, weak) IBOutlet UIImageView *imgviewAccount;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewPassword;

@property (nonatomic, strong) UserInfoModel *userInfo;

- (IBAction)loginAction;
- (IBAction)registerAction;
- (IBAction)rememberPasswordOrNot;
- (IBAction)btnAction:(id)sender;

@end

@implementation LoginViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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


#pragma mark - Init

- (void)initView
{
    // 显示是否保存密码状态
    BOOL rememberOrNot = YES;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSNumber *rememberPsw = [userDef valueForKey:kRememberPsw];
    if (rememberPsw == nil)
    {
        // 默认为记住密码
        [userDef setValue:[NSNumber numberWithBool:YES] forKey:kRememberPsw];
        [userDef synchronize];
        
        rememberOrNot = YES;
    }
    else
    {
        // 已设置
        rememberOrNot = [rememberPsw boolValue];
    }
    
    if (rememberOrNot == YES)
    {
        self.btnRemember.selected = YES;
    }
    else
    {
        self.btnRemember.selected = NO;
    }
    
    // 设置注册入口按件...<不再使用>
    self.rtlblRegister.delegate = self;
    //self.rtlblRegister.text = @"<a href='www.1663.com'><u color=white>New User</u></a>";
    self.rtlblRegister.textAlignment = RTTextAlignmentRight;
    [self.rtlblRegister setFont:[UIFont systemFontOfSize:16]];
    self.rtlblRegister.backgroundColor = [UIColor clearColor];
    [self.rtlblRegister setUserInteractionEnabled:YES];
    self.rtlblRegister.textColor = [UIColor whiteColor];
    self.rtlblRegister.hidden = YES;
    
    // 判断有无登录成功过
    NSString *userName = [userDef valueForKey:kUserName];
    NSString *password = [userDef valueForKey:kPassword];
    if (userName != nil && userName.length > 0
        && password != nil && password.length > 0)
    {
        // 用户已登录过
        self.textfieldAccount.text = userName;
        self.textfieldPassword.text = password;
    }
    else
    {
        // 用户未登录过
        self.textfieldAccount.text = nil;
        self.textfieldPassword.text = nil;
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSNumber *numberRem = [userDef valueForKey:kRememberPsw];
        if (numberRem != nil)
        {
            BOOL rememberFlag = [numberRem boolValue];
            if (rememberFlag == YES)
            {
                if (userName != nil && userName.length > 0)
                {
                    self.textfieldAccount.text = userName;
                }
            }
        }
    }
    
    UIImage *img = [UIImage imageNamed:@"img_input"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    self.imgviewAccount.image = img;
    self.imgviewPassword.image = img;
    
    UIImage *imgBtn = [UIImage imageNamed:@"btn_register"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    UIImage *imgBtn_ = [UIImage imageNamed:@"btn_register_press"];
    imgBtn_ = [imgBtn_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    [self.btnLogin setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [self.btnLogin setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    
    [self.btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnLogin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    self.textfieldAccount.returnKeyType = UIReturnKeyNext;
    self.textfieldPassword.returnKeyType = UIReturnKeyDone;
    
    // TEST
    //[self.btnLogin setTitleColor:[UIColor colorWithRed:(CGFloat)18/255 green:(CGFloat)82/255 blue:(CGFloat)168/255 alpha:1] forState:UIControlStateNormal];
}


#pragma mark - AutoLayout

- (void)initViewWithAutoLayout
{
    self.scrollviewWidth.constant = kScreenWidth;
    self.viewBarWidth.constant = kScreenWidth - 10*2;
    self.btnLoginWidth.constant = kScreenWidth - 20*2;
    
    if (kScreenWidth == kWidthFor5)
    {
        self.txtfieldWidth.constant = 190;
        self.txtfieldWidth_1.constant = 190;
    }
    else if (kScreenWidth == kWidthFor6)
    {
        self.txtfieldWidth.constant = 375-70*2 + 4;
        self.txtfieldWidth_1.constant = 375-70*2 + 4;
    }
    else if (kScreenWidth == kWidthFor6plus)
    {
        self.txtfieldWidth.constant = 414-70*2 + 4;
        self.txtfieldWidth_1.constant = 414-70*2 + 4;
    }
}


#pragma mark - Language

- (void)settingLanguage
{
//    NSString *strTest = NSLocalizedString(@"remember", nil);
//    NSString *strTest_ = NSLocalizedString(@"remember", conment:"Remember");
//    NSLog(@"<%@> <%@>", strTest, strTest_);
    
    NSString *strValue = locatizedString(@"remember");
    //NSLog(@"<%@>", strValue);
    [self.btnRemember setTitle:strValue forState:UIControlStateNormal];
    
    strValue = locatizedString(@"newUser");
    [self.btnRegister setTitle:strValue forState:UIControlStateNormal];
    
    strValue = locatizedString(@"login");
    [self.btnLogin setTitle:strValue forState:UIControlStateNormal];
    
    strValue = locatizedString(@"account");
    [self.textfieldAccount setPlaceholder:strValue];
    
    strValue = locatizedString(@"password");
    [self.textfieldPassword setPlaceholder:strValue];
}


#pragma mark - Test

- (void)requestTest
{
    // 第一步，创建URL
    NSURL *url = [NSURL URLWithString:@"http://115.29.105.23:8080/sales/user/Login"];
    
    // 第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    // 第三步，设置请求方式为POST，默认为GET
    [request setHTTPMethod:@"POST"];
    [request setValue:@"joye" forKey:@"email"];
    [request setValue:@"123456" forKey:@"pwd"];
    
    // 第四步，设置参数
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:@"joye" forKey:@"email"];
//    [dic setObject:@"123456" forKey:@"pwd"];

//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"joye", @"email", @"123456", @"pwd", nil];
//
//    NSString *str = [dic convertToJsonString];
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
    
    // 第五步，连接服务器
    NSURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (received == nil || error != nil)
    {
        NSLog(@"error:%@", [error description]);
    }
    else
    {
        NSString *response = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        NSLog(@"%@", response);
    }
}

- (void)requestTest01
{
    NSDictionary *userInfo = @{@"email":@"joye", @"pwd":@"123456"};
    NSString *urlPath = [VVAPIClient relativePathForUserLoginId];
    [[[VVBaseModel alloc] init] postPath:urlPath parameters:userInfo];
}


#pragma mark - BtnAction

// 登录
- (IBAction)loginAction
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
            default:
                break;
        }
        
        return;
    }
    
    //[self startLoading:kLoading];
    //[MRProgressOverlayView showOverlayAddedTo:self.scrollview animated:YES];
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager userLogin:self.textfieldAccount.text password:self.textfieldPassword.text completion:^(BOOL isSucceed, NSString *message, id data) {
        
        //[self stopLoading];
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        // {"status":0,"message":"登陆失败","data":null,"total":0}
        
        /*
        {
            "data": {
                "bossstatus": 0,
                "createtime": "",
                "department": null,
                "email": "",
                "id": 24,
                "img": null,
                "name": "brave1024@126.com",
                "open_id": null,
                "phone": "18507103285",
                "pwd": "d93a5def7511da3d0f2d171d9c344e91",
                "realname": "",
                "type": 1,
                "zhiwei": null
            },
            "message": "登陆成功",
            "status": 1,
            "total": 0
        }
        */
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"登录成功");
                    
                    self.userInfo = response.data;
                    NSLog(@"data:%@", self.userInfo);
                    
                    //
                    UserManager *userManager = [UserManager sharedInstance];
                    userManager.hasLogin = YES;
                    userManager.userInfo = response.data;
                    
                    //
                    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                    [userDef setValue:self.textfieldAccount.text forKey:kUserName];
                    [userDef setValue:self.textfieldPassword.text forKey:kPassword];
                    [userDef setBool:YES forKey:kLoginType];    // 手动登录
                    [userDef synchronize];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAutoLoginOver object:nil];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                        // 设置pin code
                        NSString *pinCode = [[NSUserDefaults standardUserDefaults] valueForKey:kPinCode];
                        if (pinCode != nil && pinCode.length > 0 && pinCode.length == 4)
                        {
                            // 已设置pincode
                            NSLog(@"已设置pincode...<不再重复设置>");
                        }
                        else
                        {
                            // 未设置pincode
                            NSLog(@"未设置pincode");
                            [self toast:@"登录成功, 请设置pin code"];
                            
                            kAppDelegate.thePin = nil;
                            [kAppDelegate setPinCode];
                        }
                        
                    }];
                }
                else
                {
                    NSLog(@"登录失败");
                    [self toast:@"登录失败"];
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
                [self toast:@"登录失败"];
            }
        }
        
    }];
}

// 注册
- (IBAction)registerAction
{
    [self hideKeyboard];
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//
- (IBAction)rememberPasswordOrNot
{
    self.btnRemember.selected = !(self.btnRemember.selected);
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setValue:[NSNumber numberWithBool:self.btnRemember.selected] forKey:kRememberPsw];
    [userDef synchronize];
    
    if (self.btnRemember.selected == YES)
    {
        NSLog(@"保存密码");
    }
    else
    {
        NSLog(@"不保存密码");
    }
}

// 第三方联合登录
- (IBAction)btnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    if (tag == kTag)
    {
        // Facebook
        [self jointLoginByFacebook];
    }
    else if (tag == kTag + 1)
    {
        // Wechat
        [self jointLoginByWechat];
        
    }
    else if (tag == kTag + 2)
    {
        // LinkedIn
        [self jointLoginByLinkedIn];
    }
}


#pragma mark - Third Part Login

- (void)jointLoginByWechat
{
    [ShareSDK getUserInfoWithType:ShareTypeWeixiTimeline
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   NSString *uId = [userInfo uid];
                                   NSString *uName = [userInfo nickname];
                                   NSString *uIcon = [userInfo profileImage];
                                   
                                   // userId:o3af9jrHFLTdL7XEoMND_lO-1ZdM, userName:夏志勇, userIcon:http://wx.qlogo.cn/mmopen/ajNVdqHZLLBGYibwThTiaBuicKdf8QxYywlQACMXn7ymiaahtp3SCGAIFicDZyXzicSGAvJhkTFNIKX0M1BuFErjcJBw/0
                                   NSLog(@"userId:%@, userName:%@, userIcon:%@", uId, uName, uIcon);
                                   
                                   // 后台根据userId来判断当前用户是否已注册(or 已授权)
                                   // 1. 若已注册（存在当前用户id）,则直接登录（返回个人信息）
                                   // 2. 若未注册（不存在当前用户id）,则后台随机生成一个账号密码,并返回个人信息
                                   [self beginJointLogin:uId withIcon:uIcon];
                               }
                               
                           }];
}

- (void)jointLoginByFacebook
{
    [ShareSDK getUserInfoWithType:ShareTypeFacebook
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   NSString *uId = [userInfo uid];
                                   NSString *uName = [userInfo nickname];
                                   NSString *uIcon = [userInfo profileImage];
                                   
                                   // userId:139894183016041, userName:夏志勇, userIcon:https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p50x50/11863357_139877969684329_5840938970745603927_n.jpg?oh=0546cfe6f7c19535ee8d5eec4ff114d0&oe=5641F15F&__gda__=1448199481_eaec8f5408485f0d481bf1119df93941
                                   NSLog(@"userId:%@, userName:%@, userIcon:%@", uId, uName, uIcon);
                                   
                                   // 后台根据userId来判断当前用户是否已注册(or 已授权)
                                   // 1. 若已注册（存在当前用户id）,则直接登录（返回个人信息）
                                   // 2. 若未注册（不存在当前用户id）,则后台随机生成一个账号密码,并返回个人信息
                                   [self beginJointLogin:uId withIcon:uIcon];
                               }
                                                              
                           }];
}

- (void)jointLoginByLinkedIn
{
    [ShareSDK getUserInfoWithType:ShareTypeLinkedIn
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   NSString *uId = [userInfo uid];
                                   NSString *uName = [userInfo nickname];
                                   NSString *uIcon = [userInfo profileImage];
                                   
                                   // userId:lo8tPh01Id, userName:夏志勇, userIcon:https://media.licdn.com/mpr/mprx/0_PumCn_vbpLkiDPcSvs4CZ_UbpKNCDG9Tven2P9hbJA4ie-LSyj4CZ6cbUFclItX8Ke4Cg5NFKnF_m6UjV0wYYBvIznFGm6TSp0wTvn86OB-mkrsAKmjfzGmcvij-F69yvyfm-kLNssC
                                   NSLog(@"userId:%@, userName:%@, userIcon:%@", uId, uName, uIcon);
                                   
                                   // 后台根据userId来判断当前用户是否已注册(or 已授权)
                                   // 1. 若已注册（存在当前用户id）,则直接登录（返回个人信息）
                                   // 2. 若未注册（不存在当前用户id）,则后台随机生成一个账号密码,并返回个人信息
                                   [self beginJointLogin:uId withIcon:uIcon];
                               }
                               
                           }];
}

// 将当前用户在第三方平台的个人信息传给后台, 以便在后台自动生成账号密码
- (void)beginJointLogin:(NSString *)userId withIcon:(NSString *)icon
{
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager userAuthLogin:userId pic:icon completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        // 1. 微信
        /*
        {
            "data": {
                "bossstatus": 0,
                "createtime": "",
                "department": null,
                "email": "",
                "id": 26,
                "img": "http://wx.qlogo.cn/mmopen/ajNVdqHZLLBGYibwThTiaBuicKdf8QxYywlQACMXn7ymiaahtp3SCGAIFicDZyXzicSGAvJhkTFNIKX0M1BuFErjcJBw/0",
                "name": "ldybc",
                "open_id": "o3af9jrHFLTdL7XEoMND_lO-1ZdM",
                "phone": "",
                "pwd": "2ed85b8028df152ccfb8ca15542e3018",
                "realname": "",
                "type": 1,
                "zhiwei": null
            },
            "message": "保存成功",
            "status": 1,
            "total": 0
        }
        */
        
        // 2. LinkedIn
        /*
        {
            "data": {
                "bossstatus": 0,
                "createtime": "",
                "department": null,
                "email": "",
                "id": 30,
                "img": "https://media.licdn.com/mpr/mprx/0_PumCn_vbpLkiDPcSvs4CZ_UbpKNCDG9Tven2P9hbJA4ie-LSyj4CZ6cbUFclItX8Ke4Cg5NFKnF_m6UjV0wYYBvIznFGm6TSp0wTvn86OB-mkrsAKmjfzGmcvij-F69yvyfm-kLNssC",
                "name": "obggy",
                "open_id": "lo8tPh01Id",
                "phone": "",
                "pwd": "4dcc3045e906caee9d401ce331862c4c",
                "realname": "",
                "type": 1,
                "zhiwei": null
            },
            "message": "保存成功",
            "status": 1,
            "total": 0
        }
        */
        
        // 3. Facebook
        /*
        {
            "data": {
                "bossstatus": 0,
                "createtime": "",
                "department": null,
                "email": "",
                "id": 33,
                "img": "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p50x50/11863357_139877969684329_5840938970745603927_n.jpg?oh=0546cfe6f7c19535ee8d5eec4ff114d0&oe=5641F15F&__gda__=1448199481_eaec8f5408485f0d481bf1119df93941",
                "name": "i2sds",
                "open_id": "139894183016041",
                "phone": "",
                "pwd": "1221722aeeea0b1bd9e422b439b13b6c",
                "realname": "",
                "type": 1,
                "zhiwei": null
            },
            "message": "保存成功",
            "status": 1,
            "total": 0
        }
        */
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"登录成功");
                    
                    self.userInfo = response.data;
                    NSLog(@"data:%@", self.userInfo);
                    
                    //
                    UserManager *userManager = [UserManager sharedInstance];
                    userManager.hasLogin = YES;
                    userManager.userInfo = response.data;
                    
                    //
                    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                    [userDef setValue:userManager.userInfo.name forKey:kUserName];
                    [userDef setValue:userManager.userInfo.pwd forKey:kPassword];
                    [userDef setBool:NO forKey:kLoginType];     // 授权登录
                    [userDef synchronize];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAutoLoginOver object:nil];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                        // 设置pin code
                        NSString *pinCode = [[NSUserDefaults standardUserDefaults] valueForKey:kPinCode];
                        if (pinCode != nil && pinCode.length > 0 && pinCode.length == 4)
                        {
                            // 已设置pincode
                            NSLog(@"已设置pincode...<不再重复设置>");
                        }
                        else
                        {
                            // 未设置pincode
                            NSLog(@"未设置pincode");
                            [self toast:@"登录成功, 请设置pin code"];
                            
                            kAppDelegate.thePin = nil;
                            [kAppDelegate setPinCode];
                        }
                        
                    }];
                }
                else
                {
                    NSLog(@"登录失败");
                    [self toast:@"登录失败"];
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
                [self toast:@"登录失败"];
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
- (int)checkContent
{
    if ([NSString checkContent:self.textfieldAccount.text] == NO)
    {
        return 1;
    }
    
    if ([NSString checkContent:self.textfieldPassword.text] == NO)
    {
        return 2;
    }
    
    if (self.textfieldAccount.text.length > 18 && self.textfieldAccount.text.length < 4)
    {
        return 3;
    }
    
    if (self.textfieldPassword.text.length > 18 && self.textfieldPassword.text.length < 4)
    {
        return 4;
    }
    
    
    return 0;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textfieldAccount)
    {
        [textField resignFirstResponder];
        [self.textfieldPassword becomeFirstResponder];
    }
    else
    {
        [self.textfieldPassword resignFirstResponder];
    }
    
    return YES;
}


#pragma mark - RTLabel delegate

// 点击超链接,打开内置浏览器
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"did select url %@", url);
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
    
//    [self presentViewController:registerVC animated:YES completion:^{
//        //
//    }];
}


@end
