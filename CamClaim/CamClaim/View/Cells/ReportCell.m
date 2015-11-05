//
//  ReportCell.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/18.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "ReportCell.h"
#import "ClaimList.h"

@implementation ReportCell

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
    
    self.lblDate.backgroundColor = [UIColor clearColor];
    self.lblTime.backgroundColor = [UIColor clearColor];
    self.lblType.backgroundColor = [UIColor clearColor];
    self.lblReimbursement.backgroundColor = [UIColor clearColor];
    self.lblIncome.backgroundColor = [UIColor clearColor];
    self.lblBalance.backgroundColor = [UIColor clearColor];
    
    self.lblDate.textColor = [UIColor colorWithRed:(CGFloat)186/255 green:(CGFloat)186/255 blue:(CGFloat)186/255 alpha:1];
    self.lblTime.textColor = [UIColor colorWithRed:(CGFloat)57/255 green:(CGFloat)186/255 blue:(CGFloat)249/255 alpha:1];
    self.lblType.textColor = [UIColor colorWithRed:(CGFloat)91/255 green:(CGFloat)91/255 blue:(CGFloat)91/255 alpha:1];
    self.lblReimbursement.textColor = [UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)46/255 blue:(CGFloat)0/255 alpha:1];
    self.lblIncome.textColor = [UIColor colorWithRed:(CGFloat)77/255 green:(CGFloat)239/255 blue:(CGFloat)131/255 alpha:1];
    self.lblBalance.textColor = [UIColor colorWithRed:(CGFloat)42/255 green:(CGFloat)184/255 blue:(CGFloat)252/255 alpha:1];
    
    self.lblDate.text = @"--";
    self.lblTime.text = @"--";
    self.lblType.text = @"--";
    self.lblReimbursement.text = @"--";
    self.lblIncome.text = @"--";
    self.lblBalance.text = @"--";
    
    if (data != nil)
    {
        if ([data isKindOfClass:[ClaimItem class]] == YES)
        {
            ClaimItem *item = (ClaimItem *)data;
            
            if (item.usetime != nil && item.usetime.length > 0)
            {
                //self.lblTime.text = item.usetime;
                
                NSArray *arrayTime = [item.usetime componentsSeparatedByString:@"/"];
                if (arrayTime.count == 2)
                {
                    self.lblDate.text = arrayTime[0];
                    self.lblTime.text = arrayTime[1];
                }
            }
            
            if (item.typeid != nil && item.typeid.length > 0)
            {
                self.lblType.text = item.typeid;
            }
            
            if (item.canmoney != nil && item.canmoney.length > 0)
            {
                self.lblReimbursement.text = item.canmoney;
            }
            
            if (item.gmoney != nil && item.gmoney.length > 0)
            {
                self.lblIncome.text = item.gmoney;
            }
            
            if (item.jiyu != nil && item.jiyu.length > 0)
            {
                self.lblBalance.text = item.jiyu;
            }
        }
    }
}

@end
