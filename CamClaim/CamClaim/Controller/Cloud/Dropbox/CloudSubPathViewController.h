//
//  CloudSubPathViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/13.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  云端子目录界面 For Dropbox

#import <UIKit/UIKit.h>

@interface CloudSubPathViewController : BaseViewController

@property int cloudType;    // 0-Baidu 1-Onedrive 2-Dropbox
@property (nonatomic, copy) NSString *dirPath;

@end
