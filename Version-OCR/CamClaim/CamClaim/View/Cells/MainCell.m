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
    if (user.userInfo.img != nil && user.userInfo.img.length > 0)
    {
        [self.imgview sd_setImageWithURL:[NSURL URLWithString:user.userInfo.img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
            
            if (item.useinfo != nil && item.useinfo.length > 0)
            {
                self.lblTitle.text = item.useinfo;
            }
            
            if (item.usetime != nil && item.usetime.length > 0)
            {
                self.lblTime.text = item.usetime;
            }
            
            if (item.canmoneyvalue != nil && item.canmoneyvalue.length > 0)
            {
                self.lblCost.text = item.canmoneyvalue;
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
        }
    }
}


@end
