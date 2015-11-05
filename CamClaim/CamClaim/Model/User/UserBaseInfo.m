//
//  UserBaseInfo.m
//  CamClaim
//
//  Created by 夏志勇 on 15/9/11.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  

#import "UserBaseInfo.h"

@implementation UserBaseInfo

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.realname = nil;
        self.nickname = nil;
        self.email = nil;
        self.phone = nil;
        self.company = nil;
        self.department = nil;
        self.position = nil;
        self.city = nil;
    }
    return self;
}

@end
