//
//  CCPoint.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CCPoint.h"

@implementation CCPoint

- (id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t subTitle:(NSString *)s
{
    self = [super init];
    if (self)
    {
        _coordinate = c;
        _title = t;
        _subTitle = s;
    }
    return self;
}

@end
