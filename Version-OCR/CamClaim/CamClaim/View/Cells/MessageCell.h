//
//  MessageCell.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/8.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  消息列表cell

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblCompany;
@property (nonatomic, weak) IBOutlet UILabel *lblTime;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewBg;
@property (nonatomic, weak) IBOutlet UILabel *lblContent;

@end
