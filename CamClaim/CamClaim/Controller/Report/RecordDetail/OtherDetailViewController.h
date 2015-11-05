//
//  OtherDetailViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  其它类型发票详情<礼物、工具、文仪用品、杂项申报>

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ClaimList.h"

@interface OtherDetailViewController : BaseViewController

@property int recordType;
@property (nonatomic, strong) ClaimItem *item;
@property (nonatomic, strong) UIImage *imgCapture;

@end
