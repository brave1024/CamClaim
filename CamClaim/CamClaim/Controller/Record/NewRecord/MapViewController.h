//
//  MapViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  地图选点

#import <UIKit/UIKit.h>
#import "TrafficTypeViewController.h"
#import "FoodTypeViewController.h"
#import "HotelTypeViewController.h"
#import "OtherTypeViewController.h"

@interface MapViewController : BaseViewController

@property BOOL startFlag;   // YES-起点 NO-终点

@property int indexVC;      // 0-交通 1-餐饮 2-酒店 3-其它
@property (nonatomic, weak) UIViewController *beforeVC;

@end
