//
//  CompanyCell.h
//  CamClaim
//
//  Created by 夏志勇 on 15/9/10.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblContent;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, weak) IBOutlet UIView *viewAdd;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewArrow;

@property (nonatomic, weak) IBOutlet UILabel *lblTip;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewSearch;

@end
