//
//  MainCell.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/6.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "MainCell.h"
#import "ClaimList.h"
#import "UIImageView+WebCache.h"

@implementation MainCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithData:(id)data
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.viewBg.backgroundColor = [UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)247/255 blue:(CGFloat)249/255 alpha:1];
    
    //self.imgview.image = [UIImage imageNamed:@"img_avatar"];
    self.lblTitle.text = @"--";
    self.lblTime.text = @"--";
    self.lblCost.text = @"--";
    self.lblStatus.text = @"--";
    
    // 显示用户图像...
    UserManager *user = [UserManager sharedInstance];
    
    // Test
    //user.userInfo.img = @"http://camclaim.cloudapp.net/img/user/YYNKCBAFFW.png";
    
    if (user.userInfo.img != nil && user.userInfo.img.length > 0)
    {
        if ([user.userInfo.img hasPrefix:@"http://"] == NO)
        {
            user.userInfo.img = [NSString stringWithFormat:@"http://%@", user.userInfo.img];
        }
        else
        {
            //
        }
        
        [self.imgview sd_setImageWithURL:[NSURL URLWithString:user.userInfo.img] placeholderImage:[UIImage imageNamed:@"img_avatar"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil)
            {
                NSLog(@"图片下载成功...<%@>", [NSURL URLWithString:user.userInfo.img]);
            }
            else
            {
                NSLog(@"图片下载失败...<%@>", [NSURL URLWithString:user.userInfo.img]);
            }
        }];
    }
    
    if (data != nil)
    {
        if ([data isKindOfClass:[ClaimItem class]] == YES)
        {
            ClaimItem *item = (ClaimItem *)data;
            
            // typeid + useinfo
            if (item.useinfo != nil && item.useinfo.length > 0)
            {
                self.lblTitle.text = item.useinfo;
                
                if (item.typeid != nil && item.typeid.length > 0)
                {
                    self.lblTitle.text = [NSString stringWithFormat:@"%@－%@", item.typeid, item.useinfo];
                }
            }
            else
            {
                if (item.typeid != nil && item.typeid.length > 0)
                {
                    self.lblTitle.text = item.typeid;
                }
            }
            
            if (item.usetime != nil && item.usetime.length > 0)
            {
                self.lblTime.text = item.usetime;
            }
            
//            if (item.canmoneyvalue != nil && item.canmoneyvalue.length > 0)
//            {
//                self.lblCost.text = item.canmoneyvalue;
//            }
            if (item.canmoney != nil && item.canmoney.length > 0)
            {
                self.lblCost.text = item.canmoney;
            }
            
//            if (item.statusname != nil && item.statusname.length > 0)
//            {
//                self.lblStatus.text = item.statusname;
//            }
            
            if (item.typeid != nil && item.typeid.length > 0)
            {
                int type = [item.typeid intValue];
                if (type == 0)
                {
                    self.lblStatus.text = @"Pending";
                }
                else if (type == 1)
                {
                    self.lblStatus.text = @"Cancel";
                }
                else if (type == 2)
                {
                    self.lblStatus.text = @"Approved";
                }
                else if (type == 3)
                {
                    self.lblStatus.text = @"Claim";
                }
            }
            
            if (item.status != nil && item.status.length > 0)
            {
                if ([item.status isEqualToString:@"pending"] == YES)
                {
                    self.lblStatus.text = @"Pending";
                    self.lblStatus.textColor = [UIColor colorWithRed:(CGFloat)57/255 green:(CGFloat)185/255 blue:(CGFloat)251/255 alpha:1];
                }
                else if ([item.status isEqualToString:@"approving"] == YES)
                {
                    self.lblStatus.text = @"Approving";
                    self.lblStatus.textColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)92/255 blue:(CGFloat)27/255 alpha:1];
                }
                else if ([item.status isEqualToString:@"approved"] == YES)
                {
                    self.lblStatus.text = @"Approved";
                    self.lblStatus.textColor = [UIColor colorWithRed:(CGFloat)81/255 green:(CGFloat)160/255 blue:(CGFloat)0/255 alpha:1];
                }
                else if ([item.status isEqualToString:@"reject"] == YES)
                {
                    self.lblStatus.text = @"Rejected";
                    self.lblStatus.textColor = [UIColor colorWithRed:(CGFloat)240/255 green:(CGFloat)0/255 blue:(CGFloat)0/255 alpha:1];
                }
                else
                {
                    self.lblStatus.text = item.status;
                    self.lblStatus.textColor = [UIColor colorWithRed:(CGFloat)57/255 green:(CGFloat)185/255 blue:(CGFloat)251/255 alpha:1];
                }
            }
        }
    }
}


@end
