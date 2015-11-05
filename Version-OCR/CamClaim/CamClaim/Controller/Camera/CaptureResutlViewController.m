//
//  CaptureResutlViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/10/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CaptureResutlViewController.h"

@interface CaptureResutlViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imgview;

@end

@implementation CaptureResutlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"CamClaim";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    // 选择照片
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    self.imgview.image = self.imgCapture;
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self initData];
    
    [self settingLanguage];
}

- (void)initView
{
    
    
}

- (void)initData
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

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

// 确定
- (void)moreAction
{
    
    
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
    
    
}




@end
