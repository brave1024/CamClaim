//
//  NoticeCell.m
//  CamClaim
//
//  Created by 夏志勇 on 15/9/8.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (selected == YES)
    {
        self.viewNumber.backgroundColor = [UIColor redColor];
    }
    else
    {
        self.viewNumber.backgroundColor = [UIColor redColor];
    }
}

- (void)configWithData:(id)data
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.imgviewPic.image = [UIImage imageNamed:@"img_avatar"];
    
    self.viewNumber.layer.masksToBounds = YES;
    self.viewNumber.layer.cornerRadius = 10;
    self.viewNumber.backgroundColor = [UIColor redColor];
    
    self.lblContent.font = [UIFont systemFontOfSize:16];
    self.lblContent.textColor = [UIColor blackColor];
    self.lblContent.backgroundColor = [UIColor clearColor];
    self.lblContent.numberOfLines = 2;
    self.lblContent.text = @"--";
    
    self.lblNumber.backgroundColor = [UIColor clearColor];
    self.lblNumber.textColor = [UIColor whiteColor];
    self.lblNumber.font = [UIFont systemFontOfSize:14];
    self.lblNumber.textAlignment = NSTextAlignmentCenter;
    self.lblNumber.text = nil;
    
    self.viewNumberWidth.constant = 20;
    
    if (data != nil)
    {
        if ([data isKindOfClass:[NSDictionary class]] == YES)
        {
            //NSDictionary *dic = (NSDictionary *)data;
            
            NSNumber *strNumber = @(268);
            if ([strNumber integerValue] < 10)
            {
                self.viewNumberWidth.constant = 20;
            }
            else if ([strNumber integerValue] >= 10)
            {
                self.viewNumberWidth.constant = 30;
            }
            self.lblNumber.text = [NSString stringWithFormat:@"%ld", (long)[strNumber integerValue]];
            
            self.lblContent.text = @"This is a message for Cam Claim. Thank you.";
        }
    }
}



@end
