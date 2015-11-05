//
//  MainCell.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/6.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  首界面列表cell

#import <UIKit/UIKit.h>

@interface MainCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *viewBg;
@property (nonatomic, weak) IBOutlet UIImageView *imgview;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblTime;
@property (nonatomic, weak) IBOutlet UILabel *lblCost;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus;

@end
