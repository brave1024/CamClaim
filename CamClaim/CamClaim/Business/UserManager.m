//
//  UserManager.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/10.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

static UserManager *userManager = nil;


+ (UserManager *)sharedInstance
{
    @synchronized (self)
    {
        if (userManager == nil)
        {
            userManager = [[UserManager alloc] init];
        }
    }
    return userManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // 初始化
        self.hasLogin = NO;
        self.userInfo = nil;
        self.allClaimStatus = nil;
        self.arrayClaim = nil;
        self.arrayCompany = nil;
    }
    return self;
}



@end
