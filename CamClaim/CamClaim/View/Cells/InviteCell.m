//
//  InviteCell.m
//  CamClaim
//
//  Created by 夏志勇 on 15/10/19.
//  Copyright © 2015年 kufa88. All rights reserved.
//

#import "InviteCell.h"
#import "NoticeInviteModel.h"

@implementation InviteCell

- (void)configWithData:(id)data
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.imgviewPic.image = [UIImage imageNamed:@"img_avatar"];
    self.lblType.text = @"--";
    self.lblCode.text = @"邀请码：--";
    self.lblCompanyName.text = @"--";
    self.lblName.text = @"--";
    self.lblEmail.text = @"--";
    
    self.lblType.textColor = [UIColor colorWithRed:(CGFloat)247/255 green:(CGFloat)107/255 blue:(CGFloat)0/255 alpha:1];
    
    NSString *strCode = locatizedString(@"msg_code");
    self.lblCode.text = [NSString stringWithFormat:@"%@:--", strCode];
    
    if (data != nil)
    {
        if ([data isKindOfClass:[NoticeInviteModel class]] == YES)
        {
            NoticeInviteModel *item = (NoticeInviteModel *)data;
            
            if (item.ytype != nil && item.ytype.length > 0)
            {
                if ([item.ytype intValue] == 1)
                {
                    self.lblType.text = @"邀请用户";
                    self.imgviewPic.image = [UIImage imageNamed:@"img_avatar"];
                    
                    NSString *strValue = locatizedString(@"msg_invite_user");
                    self.lblType.text = strValue;
                }
                else if ([item.ytype intValue] == 2)
                {
                    self.lblType.text = @"邀请公司";
                    self.imgviewPic.image = [UIImage imageNamed:@"img_company"];
                    
                    NSString *strValue = locatizedString(@"msg_invite_company");
                    self.lblType.text = strValue;
                }
            }
            else
            {
                //
            }
            
            if (item.ycode != nil && item.ycode.length > 0)
            {
                self.lblCode.text = [NSString stringWithFormat:@"邀请码：%@", item.ycode];
                
                self.lblCode.text = [NSString stringWithFormat:@"%@：%@", strCode, item.ycode];
            }
            else
            {
                //
            }
            
            if (item.companyname != nil && item.companyname.length > 0)
            {
                self.lblCompanyName.text = item.companyname;
            }
            else
            {
                //
            }
            
            if (item.manager != nil && item.manager.length > 0)
            {
                self.lblName.text = item.manager;
            }
            else
            {
                //
            }
            
            if (item.managermail != nil && item.managermail.length > 0)
            {
                self.lblEmail.text = item.managermail;
            }
            else
            {
                //
            }
            
        }
    }
}


@end
