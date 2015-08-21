//
//  CloudLoginViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  云盘登录界面

#import <UIKit/UIKit.h>

@interface CloudLoginViewController : BaseViewController

@property int cloudType;    // 0-Baidu 1-Onedrive 2-Dropbox

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgviewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textfieldWidth;

@end
