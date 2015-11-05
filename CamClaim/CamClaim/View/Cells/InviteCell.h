//
//  InviteCell.h
//  CamClaim
//
//  Created by 夏志勇 on 15/10/19.
//  Copyright © 2015年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, weak) IBOutlet UILabel *lblType;
@property (nonatomic, weak) IBOutlet UILabel *lblCode;
@property (nonatomic, weak) IBOutlet UILabel *lblCompanyName;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblEmail;

@end
