//
//  RequestModel.m
//  KufaLottery
//
//  Created by Xia Zhiyong on 14-9-18.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.PageIndex = 0;
        self.PageSize = kNumberInPage;
    }
    return self;
}

@end
