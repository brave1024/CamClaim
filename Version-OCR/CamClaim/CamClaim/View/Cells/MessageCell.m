//
//  MessageCell.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/8.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)configWithData:(id)data
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.lblCompany.backgroundColor = [UIColor clearColor];
    self.lblCompany.text = @"--";
    self.lblCompany.font = [UIFont systemFontOfSize:14];
    self.lblCompany.textColor = [UIColor darkGrayColor];
    self.lblCompany.textAlignment = NSTextAlignmentCenter;
    
    self.lblTime.backgroundColor = [UIColor clearColor];
    self.lblTime.text = @"--";
    self.lblTime.font = [UIFont systemFontOfSize:12];
    self.lblTime.textColor = [UIColor darkGrayColor];
    self.lblTime.textAlignment = NSTextAlignmentCenter;
    
    self.lblContent.backgroundColor = [UIColor clearColor];
    self.lblContent.text = @"--";
    self.lblContent.font = [UIFont systemFontOfSize:15];
    self.lblContent.textColor = [UIColor blackColor];
    self.lblContent.textAlignment = NSTextAlignmentCenter;
    self.lblContent.numberOfLines = 0;
    
    UIImage *img = [UIImage imageNamed:@"img_message"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(40, 24, 8, 24)];
    self.imgviewBg.image = img;
    
    if (data != nil)
    {
        if ([data isKindOfClass:[NSDictionary class]] == YES)
        {
            //NSDictionary *dic = (NSDictionary *)data;
            
            self.lblCompany.text = @"XiaoMi Technology Co., Ltd.";
            self.lblTime.text = @"21:08 08/9/2015";
            self.lblContent.text = @"Your form has been submitted, please wait for approval, you will receive a notice after the success.";
        }
    }
}


@end
