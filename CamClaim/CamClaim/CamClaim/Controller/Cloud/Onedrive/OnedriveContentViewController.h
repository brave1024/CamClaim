//
//  OnedriveContentViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/14.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  云端主目录界面 For Onedrive

#import <UIKit/UIKit.h>
// Onedrive
#import <OneDriveSDK/OneDriveSDK.h>

@interface OnedriveContentViewController : BaseViewController

@property (strong, nonatomic) ODClient *client;

@end
