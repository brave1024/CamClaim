//
//  UISegmentedControl+Font.m
//  KufaLottery
//
//  Created by Ian on 14-12-29.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import "UISegmentedControl+Font.h"

@implementation UISegmentedControl (Font)

- (void)setupForFont
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.f]};
    [self setTitleTextAttributes:dic forState:UIControlStateNormal];
}

@end
