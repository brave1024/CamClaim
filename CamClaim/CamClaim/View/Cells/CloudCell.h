//
//  CloudCell.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/13.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  云盘内容列表cell

#import <UIKit/UIKit.h>

@interface CloudCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgviewType;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblSize;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewArrow;

@end
