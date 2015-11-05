//
//  BindingCell.m
//  CamClaim
//
//  Created by 夏志勇 on 15/9/17.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "BindingCell.h"

@implementation BindingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithData:(id)data
{
    // 不显示箭头
    self.imgviewArrow.hidden = YES;
    
    self.imgviewPic.image = nil;
    
    self.lblTitle.text = nil;
    self.lblTitle.textAlignment = NSTextAlignmentLeft;
    self.lblTitle.textColor = [UIColor blackColor];
    self.lblTitle.font = [UIFont systemFontOfSize:16];
    self.lblTitle.backgroundColor = [UIColor clearColor];
    
    self.btnBind.hidden = YES;
    
    if (data != nil)
    {
        if ([data isKindOfClass:[NSDictionary class]] == YES)
        {
            NSDictionary *dic = (NSDictionary *)data;
            
            self.imgviewPic.image = [UIImage imageNamed:dic[@"imgName"]];
            self.lblTitle.text = dic[@"title"];
            
            NSString *key = dic[@"cellid"];
            if (key != nil && key.length > 0)
            {
                self.btnBind.hidden = NO;
             
                UserManager *userManager = [UserManager sharedInstance];
                
                // 判断指定第三方平台是否已绑定
                if ([key isEqualToString:@"facebook"] == YES)
                {
                    if (userManager.userInfo.facebook_open_id != nil && userManager.userInfo.facebook_open_id.length > 0)
                    {
                        // 已绑定
                        [self.btnBind setTitle:@"解绑" forState:UIControlStateNormal];
                    }
                    else
                    {
                        // 未绑定
                        [self.btnBind setTitle:@"绑定" forState:UIControlStateNormal];
                    }
                }
                else if ([key isEqualToString:@"wechat"] == YES)
                {
                    if (userManager.userInfo.open_id != nil && userManager.userInfo.open_id.length > 0)
                    {
                        // 已绑定
                        [self.btnBind setTitle:@"解绑" forState:UIControlStateNormal];
                    }
                    else
                    {
                        // 未绑定
                        [self.btnBind setTitle:@"绑定" forState:UIControlStateNormal];
                    }
                }
                else if ([key isEqualToString:@"linkedin"] == YES)
                {
                    if (userManager.userInfo.linkeid_open_id != nil && userManager.userInfo.linkeid_open_id.length > 0)
                    {
                        // 已绑定
                        [self.btnBind setTitle:@"解绑" forState:UIControlStateNormal];
                    }
                    else
                    {
                        // 未绑定
                        [self.btnBind setTitle:@"绑定" forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
}

- (IBAction)btnTouchAciton
{
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(userBindingAction:)] == YES
        && [self.delegate conformsToProtocol:@protocol(BindingCellDelegate)] == YES)
    {
        [self.delegate userBindingAction:self];
    }
}


@end
