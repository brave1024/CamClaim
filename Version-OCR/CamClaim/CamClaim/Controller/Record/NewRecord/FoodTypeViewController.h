//
//  FoodTypeViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  餐饮类型发票

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

// 只取前3种状态
typedef NS_ENUM(NSInteger, typeFood) {
    typeFoodBreakfast = 0,      // 早餐
    typeFoodLunch,              // 中餐
    typeFoodSupper,             // 晚餐
    typeFoodOther = -1          // 其它
};

@interface FoodTypeViewController : BaseViewController

- (void)getStartLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address;

@end
