//
//  NSArray+Utils.m
//  KufaLottery
//
//  Created by Xia Zhiyong on 14-12-5.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)

// 用于数组越界检查
- (id)getObjectAtIndex:(NSInteger)index
{
    if (self.count > 0 && self.count > index)
    {
        return [self objectAtIndex:index];
    }
    else
    {
        LogDebug(@"index %ld beyond (%ld)->bounds for current array", (long)index, (unsigned long)self.count);
        return nil;
    }
}

@end
