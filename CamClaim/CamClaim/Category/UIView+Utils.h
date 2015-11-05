//
//  UIView+Utils.h
//  KufaLottery
//
//  Created by Xia Zhiyong on 14-12-10.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)


@property (assign, nonatomic) CGFloat originX;
@property (assign, nonatomic) CGFloat originY;
@property (assign, nonatomic) CGFloat sizeWidth;
@property (assign, nonatomic) CGFloat sizeHeight;

+ (instancetype)viewFromNib;
+ (instancetype)viewFromNibForDifferentDevice;
- (void)configWithData:(id)data;

@end
