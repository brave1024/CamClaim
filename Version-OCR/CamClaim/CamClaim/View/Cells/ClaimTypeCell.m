//
//  ClaimTypeCell.m
//  CamClaim
//
//  Created by 夏志勇 on 15/9/29.
//  Copyright © 2015年 kufa88. All rights reserved.
//

#import "ClaimTypeCell.h"

@implementation ClaimTypeCell

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
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (data != nil)
    {
        NSDictionary *dic = (NSDictionary *)data;
        NSLog(@"%@", dic);
        
        self.lblTitle.text = dic[@"title"];
        self.imgviewPic.image = [UIImage imageNamed:dic[@"imgName"]];
        
        NSString *key = dic[@"key"];
        NSString *strValue = locatizedString(key);
        self.lblTitle.text = strValue;
    }
}

@end
