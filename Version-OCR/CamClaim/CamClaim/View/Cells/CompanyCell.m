//
//  CompanyCell.m
//  CamClaim
//
//  Created by 夏志勇 on 15/9/10.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CompanyCell.h"
#import "CompanyModel.h"

@implementation CompanyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}

- (void)configWithData:(id)data
{
    self.imgviewPic.hidden = YES;
    self.imgviewArrow.hidden = YES;
    self.viewAdd.hidden = YES;
    self.lblContemt.text = @"--";
    self.lblContemt.textColor = [UIColor blackColor];
    
    if (data != nil)
    {
        if ([data isKindOfClass:[CompanyModel class]] == YES)
        {
            // 我的公司
            
            CompanyModel *item = (CompanyModel *)data;
            self.lblContemt.text = item.companyinfo;
        }
        else if ([data isKindOfClass:[NSString class]] == YES)
        {
            // 加入公司
            
            
        }
    }
}

@end
