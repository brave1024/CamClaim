//
//  NoticeCell.h
//  CamClaim
//
//  Created by 夏志勇 on 15/9/8.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  通知cell

#import <UIKit/UIKit.h>

@interface NoticeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, weak) IBOutlet UILabel *lblContent;
@property (nonatomic, weak) IBOutlet UIView *viewNumber;
@property (nonatomic, weak) IBOutlet UILabel *lblNumber;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewNumberWidth;

@end
