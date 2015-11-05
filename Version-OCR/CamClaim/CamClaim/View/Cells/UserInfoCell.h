//
//  UserInfoCell.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblContent;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewArrow;

@end
