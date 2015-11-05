//
//  CCPoint.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>  

@interface CCPoint : NSObject <MKAnnotation>

// 实现MKAnnotation协议必须要定义这个属性
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
// 标题
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

// 初始化方法
- (id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t subTitle:(NSString *)s;

@end
