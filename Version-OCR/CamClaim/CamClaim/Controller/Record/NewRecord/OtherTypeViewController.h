//
//  OtherTypeViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  其它类型发票<礼物、工具、文仪用品、杂项申报>

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface OtherTypeViewController : BaseViewController

@property int recordType;

- (void)getStartLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address;

@end
