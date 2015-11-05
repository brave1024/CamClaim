//
//  FoodDetailViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  膳食类型发票详情

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ClaimList.h"

@interface FoodDetailViewController : BaseViewController

@property (nonatomic, strong) ClaimItem *item;
@property (nonatomic, strong) UIImage *imgCapture;

@end
