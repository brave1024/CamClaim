//
//  SettingCell.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

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
    self.lblContent.text = nil;
    
    if (data != nil)
    {
        NSDictionary *dic = (NSDictionary *)data;
        
        self.lblTitle.text = dic[@"title"];
        
        NSString *strContent = dic[@"content"];
        if (strContent != nil && strContent.length > 0)
        {
            self.lblContent.text = strContent;
        }
    }
}


@end
