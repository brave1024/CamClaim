//
//  NSNumber+Utils.m
//  KufaLottery
//
//  Created by Ian on 15-1-21.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "NSNumber+Utils.h"

@implementation NSNumber (Utils)

+ (instancetype)checkBoolNumber:(NSNumber *)boolNumber;
{
    if (boolNumber == nil)
    {
        return [NSNumber numberWithBool:NO];
    }
    
    return boolNumber;
}

@end
