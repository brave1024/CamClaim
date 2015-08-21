//
//  CloudLoginViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CloudLoginViewController.h"

@interface CloudLoginViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollview;

@property (nonatomic, weak) IBOutlet UIImageView *imgviewIcon;
@property (nonatomic, weak) IBOutlet UILabel *lblType;

@property (nonatomic, weak) IBOutlet UIImageView *imgviewAccount;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewPassword;

@property (nonatomic, weak) IBOutlet UITextField *textfieldAccount;
@property (nonatomic, weak) IBOutlet UITextField *textfieldPassword;

@property (nonatomic, weak) IBOutlet UIButton *btnSetup;

- (IBAction)setupAction;

@end

@implementation CloudLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.title = @"云盘登录";
    self.navView.lblTitle.text = @"云盘登录";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    UIImage *img = [UIImage imageNamed:@"btn_cloud_setting"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    self.imgviewAccount.image = img;
    self.imgviewPassword.image = img;
        
    UIImage *imgBtn = [UIImage imageNamed:@"btn_cloud_login"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
//    UIImage *imgBtn_ = [UIImage imageNamed:@"btn_cloud_press"];
//    imgBtn_ = [imgBtn_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    [self.btnSetup setBackgroundImage:imgBtn forState:UIControlStateNormal];
//    [self.btnSetup setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    [self.btnSetup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSetup setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    self.textfieldAccount.returnKeyType = UIReturnKeyNext;
    self.textfieldPassword.returnKeyType = UIReturnKeyDone;
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
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
//    [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
//        // 点击按钮隐藏菜单栏后的动画
//        [self.viewDeckController previewBounceView:IIViewDeckLeftSide toDistance:20.0f duration:0.6f numberOfBounces:2 dampingFactor:0.40f callDelegate:YES completion:^(IIViewDeckController *controller, BOOL success) {
//            
//        }];
//    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - AutoLayout

- (void)initViewWithAutoLayout
{
    self.scrollviewWidth.constant = kScreenWidth;
    self.imgviewWidth.constant = kScreenWidth - 20*2;
    self.textfieldWidth.constant = kScreenWidth - 70*2;
    
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


#pragma mark - BtnTouchAction

- (IBAction)setupAction
{
    
    
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


@end
