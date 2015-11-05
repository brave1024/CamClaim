//
//  CameraViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/7.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  拍照界面...<显示扫描结果>...<不再使用>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, typeOcr) {
    typeOcrEnglish,
    typeOcrSimChinese,
    typeOcrTraChinese
};


@interface CameraViewController : BaseViewController

@property (nonatomic, strong) UIImage *imgCapture;

@end
