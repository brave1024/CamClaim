//
//  UserInfoCell.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithData:(id)data
{
    self.imgviewPic.image = nil;
    self.lblTitle.text = @"--";
    self.lblContent.text = @"--";
    self.imgviewArrow.hidden = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (data != nil)
    {
        NSDictionary *dic = (NSDictionary *)data;
        NSLog(@"%@", dic);
        
        // 标题
        self.lblTitle.text = dic[@"title"];
        
        NSString *strValue = locatizedString(dic[@"description"]);
        self.lblTitle.text = strValue;
        
        // 图标
        self.imgviewPic.image = [UIImage imageNamed:dic[@"imgName"]];
        
//        NSString *strContent = dic[@"content"];
//        if (strContent != nil && strContent.length > 0)
//        {
//            self.lblContent.text = strContent;
//        }
        
        UserManager *userManager = [UserManager sharedInstance];
        UserInfoModel *userInfo = userManager.userInfo;
        
        NSString *cellid = dic[@"cellid"];
        if ([cellid isEqualToString:@"realname"] == YES)
        {
            self.lblContent.text = userInfo.realname;
        }
        else if ([cellid isEqualToString:@"nickname"] == YES)
        {
            self.lblContent.text = userInfo.nickname;
        }
        else if ([cellid isEqualToString:@"email"] == YES)
        {
            self.lblContent.text = userInfo.email;
        }
        else if ([cellid isEqualToString:@"phone"] == YES)
        {
            self.lblContent.text = userInfo.phone;
        }
//        else if ([cellid isEqualToString:@"company"] == YES)
//        {
//            self.lblContent.text = userInfo.company;
//        }
        else if ([cellid isEqualToString:@"department"] == YES)
        {
            self.lblContent.text = userInfo.department;
        }
        else if ([cellid isEqualToString:@"position"] == YES)
        {
            self.lblContent.text = userInfo.zhiwei;
        }
//        else if ([cellid isEqualToString:@"city"] == YES)
//        {
//            self.lblContent.text = userInfo.city;
//        }
        
        BOOL showArrow = [dic[@"showArrow"] boolValue];
        if (showArrow == YES)
        {
            NSLog(@"show");
            self.imgviewArrow.hidden = NO;
        }
        else
        {
            NSLog(@"hide");
            self.imgviewArrow.hidden = YES;
        }
    }
}


@end
