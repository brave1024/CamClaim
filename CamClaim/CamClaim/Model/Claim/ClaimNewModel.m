//
//  ClaimNewModel.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "ClaimNewModel.h"

@implementation ClaimNewModel

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.client = nil;
        self.purpose = nil;
        self.money = nil;
        self.time = nil;
        self.claimType = nil;
        self.company = nil;
        self.location = nil;
        
        self.longitude = nil;
        self.latitude = nil;
        self.userid = nil;
    }
    return self;
}

@end
