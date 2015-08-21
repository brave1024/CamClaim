//
//  CloudContentDetailViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/13.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  云端文件详情界面 For Dropbox

#import <UIKit/UIKit.h>
// Dropbox
#import <DropboxSDK/DropboxSDK.h>

@interface CloudContentDetailViewController : BaseViewController

@property int cloudType;    // 0-Baidu 1-Onedrive 2-Dropbox
@property (nonatomic, strong) DBMetadata *fileItem;

@end
