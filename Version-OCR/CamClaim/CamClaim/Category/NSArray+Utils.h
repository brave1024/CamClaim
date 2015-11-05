//
//  NSArray+Utils.h
//  KufaLottery
//
//  Created by Xia Zhiyong on 14-12-5.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utils)

// 用于数组越界保护
- (id)getObjectAtIndex:(NSInteger)index;

@end
