//
//  UserAvatarCell.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "UserAvatarCell.h"

@implementation UserAvatarCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithData:(id)data
{
    self.lblTitle.text = @"--";

    self.imgviewPic.image = [UIImage imageNamed:@"img_avatar"];
    self.imgviewPic.layer.masksToBounds = YES;
    self.imgviewPic.layer.cornerRadius = 26;
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (data != nil)
    {
        if ([data isKindOfClass:[NSDictionary class]] == YES)
        {
            NSDictionary *dic = (NSDictionary *)data;
            
            NSString *title = dic[@"title"];
            self.lblTitle.text = title;
        }
    }
}


@end
