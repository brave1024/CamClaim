//
//  CameraViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/7.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController () <IIViewDeckControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imgview;
@property (nonatomic, weak) IBOutlet UIView *viewResult;

@property (nonatomic, weak) IBOutlet UIButton *btnComfirm;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navView.lblTitle.text = @"拍照";
//    self.navView.lblTitle.hidden = YES;
//    self.navView.imgLogo.hidden = NO;
//    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    self.navView.lblTitle.text = @"拍照";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    self.viewContent.backgroundColor = [UIColor blackColor];
    
    UIImage *imgBtn = [UIImage imageNamed:@"btn_bg_submit"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    UIImage *imgBtn_ = [UIImage imageNamed:@"btn_bg_submit_press"];
    imgBtn_ = [imgBtn_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    [self.btnComfirm setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [self.btnComfirm setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    
    [self.btnComfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnComfirm setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    self.imgview.image = self.imgCapture;
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


@end
