//
//  OtherDetailViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "OtherDetailViewController.h"

@interface OtherDetailViewController ()

@end

@implementation OtherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"其它";
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    if (self.recordType == 3)
    {
        self.navView.lblTitle.text = @"禮物";
    }
    else if (self.recordType == 4)
    {
        self.navView.lblTitle.text = @"工具";
    }
    else if (self.recordType == 5)
    {
        self.navView.lblTitle.text = @"文儀用品";
    }
    else if (self.recordType == 6)
    {
        self.navView.lblTitle.text = @"雜項開支";
    }
    
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
    [self.navigationController popViewControllerAnimated:YES];
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


@end
