//
//  TrafficTypeViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  交通类型发票

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TrafficTypeViewController : BaseViewController

@property (nonatomic, strong) UIImage *imgCapture;

- (void)setImageForClaim:(UIImage *)img;

- (void)getStartLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address;
- (void)getEndLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address;

@end
