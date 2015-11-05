//
//  UITableViewCell+Utils.h
//  OpenOOIM
//
//  Created by Ian on 14-8-19.
//  Copyright (c) 2014年 武汉九午科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Utils)

+ (instancetype)cellFromNib;
+ (instancetype)cellFromNibForDifferentDevice;
+ (instancetype)cellFromNib:(UINib *)nib;
- (void)configWithData:(id)data;

@end
