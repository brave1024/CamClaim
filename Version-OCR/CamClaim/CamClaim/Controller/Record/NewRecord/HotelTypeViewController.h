//
//  HotelTypeViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  住宿类型发票

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HotelTypeViewController : BaseViewController

- (void)getStartLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address;

@end