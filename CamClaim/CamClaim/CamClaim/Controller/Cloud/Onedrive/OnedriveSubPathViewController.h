//
//  OnedriveSubPathViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/14.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  云端子目录界面 For Onedrive

#import <UIKit/UIKit.h>
// Onedrive
#import <OneDriveSDK/OneDriveSDK.h>

@interface OnedriveSubPathViewController : BaseViewController

@property (strong, nonatomic) ODClient *client;
@property (strong, nonatomic) ODItem *currentItem;

@end
