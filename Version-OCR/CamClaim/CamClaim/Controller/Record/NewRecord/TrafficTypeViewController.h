//
//  TrafficTypeViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  交通类型发票

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

// 只取前4种状态
typedef NS_ENUM(NSInteger, typeTraffic) {
    typeTrafficCar = 0,         // 汽车
    typeTrafficTrain,           // 火车
    typeTrafficFlight,          // 飞机
    typeTrafficShip,            // 轮船
    typeTrafficMetro,           // 地铁
    typeTrafficOther = -1       // 其它
};

@interface TrafficTypeViewController : BaseViewController

- (void)getStartLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address;
- (void)getEndLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address;

@end
