//
//  CloudViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/11.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CloudViewController.h"
// VC
#import "CloudLoginViewController.h"
#import "CloudContentViewController.h"
#import "OnedriveContentViewController.h"
// Dropbox
#import <DropboxSDK/DropboxSDK.h>
// Onedrive
#import <OneDriveSDK/OneDriveSDK.h>

@interface CloudViewController ()

@property (nonatomic, weak) IBOutlet UIButton *btnBaidu;
@property (nonatomic, weak) IBOutlet UIButton *btnOnedrive;
@property (nonatomic, weak) IBOutlet UIButton *btnDropbox;
@property (nonatomic, weak) IBOutlet UIButton *btnSetting;

@property (strong, nonatomic) ODClient *client;

- (IBAction)btnTouchAction:(id)sender;

@end

@implementation CloudViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.title = @"云盘";
    
    self.navView.lblTitle.hidden = YES;
    self.navView.imgLogo.hidden = NO;
    
    // 当前导航栏左侧图标替换
    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
//    UIImage *imgBtn = [UIImage imageNamed:@"btn_cloud"];
//    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
//    
//    UIImage *imgBtn_ = [UIImage imageNamed:@"btn_cloud_press"];
//    imgBtn_ = [imgBtn_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    UIImage *imgBtn = [UIImage imageNamed:@"new_btn_capture"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    
    [self.btnBaidu setBackgroundImage:imgBtn forState:UIControlStateNormal];
//    [self.btnBaidu setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    [self.btnBaidu setImage:[UIImage imageNamed:@"icon_Baidu"] forState:UIControlStateNormal];
    [self.btnBaidu setImage:[UIImage imageNamed:@"icon_Baidu"] forState:UIControlStateHighlighted];
//    [self.btnBaidu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.btnBaidu setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [self.btnOnedrive setBackgroundImage:imgBtn forState:UIControlStateNormal];
//    [self.btnOnedrive setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    [self.btnOnedrive setImage:[UIImage imageNamed:@"icon_Onedrive"] forState:UIControlStateNormal];
    [self.btnOnedrive setImage:[UIImage imageNamed:@"icon_Onedrive"] forState:UIControlStateHighlighted];
//    [self.btnOnedrive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.btnOnedrive setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [self.btnDropbox setBackgroundImage:imgBtn forState:UIControlStateNormal];
//    [self.btnDropbox setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    [self.btnDropbox setImage:[UIImage imageNamed:@"icon_Dropbox"] forState:UIControlStateNormal];
    [self.btnDropbox setImage:[UIImage imageNamed:@"icon_Dropbox"] forState:UIControlStateHighlighted];
//    [self.btnDropbox setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.btnDropbox setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    UIImage *img = [UIImage imageNamed:@"new_btn_setting"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    
//    UIImage *img_ = [UIImage imageNamed:@"btn_cloud_setting_press"];
//    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    [self.btnSetting setBackgroundImage:img forState:UIControlStateNormal];
//    [self.btnSetting setBackgroundImage:img_ forState:UIControlStateHighlighted];
    [self.btnSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSetting setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
    //[self.viewDeckController toggleLeftView];
    [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        // 点击按钮隐藏菜单栏后的动画
        //[self.viewDeckController previewBounceView:IIViewDeckLeftSide];
        [self.viewDeckController previewBounceView:IIViewDeckLeftSide toDistance:20.0f duration:0.6f numberOfBounces:2 dampingFactor:0.40f callDelegate:YES completion:^(IIViewDeckController *controller, BOOL success) {
            
        }];
    }];
}


#pragma mark - Btn Touch

- (IBAction)btnTouchAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    switch (tag) {
        case kTag:
        {
            // Baidu
            
            CloudLoginViewController *loginVC = [[CloudLoginViewController alloc] initWithNibName:@"CloudLoginViewController" bundle:nil];
            loginVC.cloudType = 0;
            [self.navigationController pushViewController:loginVC animated:YES];
            
            //
            
            break;
        }
        case kTag + 1:
        {
            // Onedrive
            
            CloudLoginViewController *loginVC = [[CloudLoginViewController alloc] initWithNibName:@"CloudLoginViewController" bundle:nil];
            loginVC.cloudType = 1;
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
            
#warning TODO: 不需要每次都进行登录授权；而应该是登录授权一次后，下次app启动时直接获取onedrive对象并使用...~!@
            
            if (self.client == nil)
            {
                // 登录授权界面的状态栏文字颜色需改为黑色
                // 且需到子界面进行登录授权操作
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                
                // 开始连接(授权)
                [ODClient authenticatedClientWithCompletion:^(ODClient *client, NSError *error){
                    
                    if (!error)
                    {
                        NSLog(@"Onedrive授权成功");
                        
                        // ODClient:
                        // baseURL: https://api.onedrive.com/v1.0
                        
                        self.client = client;
                        
                        // 当前为子线程...~!@
                        // 若在子线程中进行界面跳转 or UI更新，则会有相当长时间的延迟
                        
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                            
                            // 跳转到内容界面
                            OnedriveContentViewController *contentVC = [[OnedriveContentViewController alloc] initWithNibName:@"OnedriveContentViewController" bundle:nil];
                            contentVC.client = self.client;
                            [self.navigationController pushViewController:contentVC animated:YES];
                        });
                    }
                    else
                    {
                        NSLog(@"Onedrive授权失败:%@", [error description]);
                        
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                            [self toast:@"Onedrive授权失败或取消"];
                        });
                    }
                }];
            }
            else
            {
                // 已授权
                OnedriveContentViewController *contentVC = [[OnedriveContentViewController alloc] initWithNibName:@"OnedriveContentViewController" bundle:nil];
                contentVC.client = self.client;
                [self.navigationController pushViewController:contentVC animated:YES];
            }
            
            break;
        }
        case kTag + 2:
        {
            // Dropbox
            
//            CloudLoginViewController *loginVC = [[CloudLoginViewController alloc] initWithNibName:@"CloudLoginViewController" bundle:nil];
//            loginVC.cloudType = 2;
//            [self.navigationController pushViewController:loginVC animated:YES];
            
            if ([[DBSession sharedSession] isLinked] == NO)
            {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                
                // 开始连接(授权)
                [[DBSession sharedSession] linkFromController:self];
            }
            else
            {
                // 已连接
                
                // Test For Cancal Auth
//                [[DBSession sharedSession] unlinkAll];
//                return;
                
                // 授权成功后，跳转到指定界面
                CloudContentViewController *contentVC = [[CloudContentViewController alloc] initWithNibName:@"CloudContentViewController" bundle:nil];
                contentVC.cloudType = 2;
                [self.navigationController pushViewController:contentVC animated:YES];
            }
            
            break;
        }
        case kTag + 3:
        {
            // Setting
            
            
            
            break;
        }
        default:
            break;
    }
}


@end
