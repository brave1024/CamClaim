//
//  OnedriveDetailViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/14.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  云端文件详情界面 For Onedrive

#import <UIKit/UIKit.h>
// Onedrive
#import <OneDriveSDK/OneDriveSDK.h>

@interface OnedriveDetailViewController : BaseViewController

@property (strong, nonatomic) ODClient *client;
@property (strong, nonatomic) ODItem *item;

@end
