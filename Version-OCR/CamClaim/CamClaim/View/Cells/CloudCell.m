//
//  CloudCell.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/13.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CloudCell.h"
// Dropbox
#import <DropboxSDK/DropboxSDK.h>
// Onedrive
#import <OneDriveSDK/OneDriveSDK.h>

@implementation CloudCell

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
    
    self.lblName.font = [UIFont systemFontOfSize:15];
    self.lblName.textColor = [UIColor blackColor];
    self.lblName.textAlignment = NSTextAlignmentLeft;
    
    self.lblSize.font = [UIFont systemFontOfSize:13];
    self.lblSize.textColor = [UIColor darkGrayColor];
    self.lblSize.textAlignment = NSTextAlignmentLeft;
    
    // 先初始化
    self.imgviewType.image = [UIImage imageNamed:@"icon_default"];
    self.lblName.text = @"--";
    self.lblSize.text = @"--";
    self.imgviewArrow.hidden = YES;
    
    if (data != nil)
    {
        if ([data isKindOfClass:[DBMetadata class]] == YES)
        {
            // Dropbox
            DBMetadata *item = (DBMetadata *)data;
            
            self.lblName.text = item.filename;
            self.lblSize.text = item.humanReadableSize;
            
            // 判断是否为文件夹
            if (item.isDirectory == YES)
            {
                // 文件夹
                self.imgviewType.image = [UIImage imageNamed:@"icon_folder"];
                self.lblSize.text = @"文件夹";
                self.imgviewArrow.hidden = NO;
            }
            else
            {
                // 文件
                NSString *strFormat = [[item.path pathExtension] lowercaseString];
                LogDebug(@"file format:%@", strFormat);
                
                // 根据文件格式显示不同的图片
                [self showFileIcon:strFormat];
            }
        }
        else if ([data isKindOfClass:[ODItem class]] == YES)
        {
            // Onedrive
            ODItem *item = (ODItem *)data;
            
            // 名称
            self.lblName.text = item.name;
            
            // 1. 先获取大小
            NSDictionary *dicItem = [item dictionaryFromItem];
            
            long size = [(NSNumber *)dicItem[@"size"] longValue];
            LogDebug(@"size:%ld B", size);
            
            // 最终用于显示的大小
            NSString *strSize = [self getSizeForShow:size];
            
            // 2. 再判断是文件 or 文件夹
            id folder = dicItem[@"folder"];
            id file = dicItem[@"file"];
            if (folder != nil && file == nil)
            {
                // 为文件夹
                //self.lblSize.text = @"文件夹";
                //self.lblSize.text = [NSString stringWithFormat:@"文件夹 %@", strSize];
                
                NSDictionary *dic = (NSDictionary *)folder;
                int count = [(NSNumber *)dic[@"childCount"] intValue];
                self.lblSize.text = [NSString stringWithFormat:@"文件夹 (大小:%@, 文件个数:%d)", strSize, count];
                
                self.imgviewType.image = [UIImage imageNamed:@"icon_folder"];
                self.imgviewArrow.hidden = NO;
            }
            else
            {
                // 为文件
                
                NSString *strName = item.name;
                NSArray *arrayTemp = [strName componentsSeparatedByString:@"."];
                if (arrayTemp != nil && arrayTemp.count >= 2)
                {
                    NSString *strFormat = [arrayTemp lastObject];
                    LogDebug(@"file format:%@", strFormat);
                    
                    // 根据文件格式显示不同的图片
                    [self showFileIcon:strFormat];
                }
                else
                {
                    // 未知
                }
                
                self.lblSize.text = [NSString stringWithFormat:@"%@", strSize];
            }
        }
        else
        {
            //
        }
    }
}

- (void)showFileIcon:(NSString *)strFormat
{
    // 图片
    if ([strFormat isEqualToString:@"jpg"] == YES
        || [strFormat isEqualToString:@"jpeg"] == YES
        || [strFormat isEqualToString:@"png"] == YES
        || [strFormat isEqualToString:@"gif"] == YES
        || [strFormat isEqualToString:@"bmp"] == YES
        // ...~!@
        || [strFormat isEqualToString:@"tiff"] == YES
        || [strFormat isEqualToString:@"dxf"] == YES)
    {
        self.imgviewType.image = [UIImage imageNamed:@"icon_image"];
        self.imgviewArrow.hidden = NO;
    }
    
    // 音频: mp3 caf wav aif <确定 mp3/caf/wav 一定可以播放>
    if ([strFormat isEqualToString:@"mp3"] == YES
        || [strFormat isEqualToString:@"caf"] == YES
        || [strFormat isEqualToString:@"wav"] == YES
        // ...~!@
        || [strFormat isEqualToString:@"aif"] == YES
        || [strFormat isEqualToString:@"wma"] == YES
        || [strFormat isEqualToString:@"aac"] == YES
        || [strFormat isEqualToString:@"amr"] == YES
        || [strFormat isEqualToString:@"pcm"] == YES
        || [strFormat isEqualToString:@"rm"] == YES
        || [strFormat isEqualToString:@"midi"] == YES
        || [strFormat isEqualToString:@"asf"] == YES)
    {
        self.imgviewType.image = [UIImage imageNamed:@"icon_music"];
    }
    
    // 视频: mp4 mov m4v 3gp <确定 mp4/mov/m4v 一定可以播放>
    if ([strFormat isEqualToString:@"mp4"] == YES
        || [strFormat isEqualToString:@"mov"] == YES
        || [strFormat isEqualToString:@"m4v"] == YES
        // ...~!@
        || [strFormat isEqualToString:@"avi"] == YES
        || [strFormat isEqualToString:@"wma"] == YES
        || [strFormat isEqualToString:@"3gp"] == YES
        || [strFormat isEqualToString:@"rm"] == YES
        || [strFormat isEqualToString:@"rmvb"] == YES
        || [strFormat isEqualToString:@"wmv"] == YES
        || [strFormat isEqualToString:@"mpg"] == YES)
    {
        self.imgviewType.image = [UIImage imageNamed:@"icon_movie"];
    }
    
    // 文档:
    if ([strFormat isEqualToString:@"doc"] == YES
        || [strFormat isEqualToString:@"docx"] == YES
        || [strFormat isEqualToString:@"docm"] == YES
        || [strFormat isEqualToString:@"ppt"] == YES
        || [strFormat isEqualToString:@"pptx"] == YES
        || [strFormat isEqualToString:@"xls"] == YES
        || [strFormat isEqualToString:@"xlsx"] == YES
        || [strFormat isEqualToString:@"pdf"] == YES)
    {
        self.imgviewType.image = [UIImage imageNamed:@"icon_doc"];
    }
    
    // txt文本:
    if ([strFormat isEqualToString:@"txt"] == YES)
    {
        self.imgviewType.image = [UIImage imageNamed:@"icon_txt"];
    }
    
    // 压缩文件:
    if ([strFormat isEqualToString:@"zip"] == YES
        || [strFormat isEqualToString:@"rar"] == YES)
    {
        self.imgviewType.image = [UIImage imageNamed:@"icon_zip"];
    }
}

- (NSString *)getSizeForShow:(long)size
{
    // 文件 or 文件夹 大小
    NSString *strSize = nil;
    
    long kb = 1024;
    long mb = kb * 1024;
    long gb = mb * 1024;
    
    if (size >= gb)
    {
        strSize = [NSString stringWithFormat:@"%.2f GB", (float) size / gb];
    }
    else if (size >= mb)
    {
        float f = (float) size / mb;
        strSize = [NSString stringWithFormat:@"%.2f MB", f];
//        if (f > 100)
//        {
//            strSize = [NSString stringWithFormat:@"%.0f MB", f];
//        }
//        else
//        {
//            strSize = [NSString stringWithFormat:@"%.1f MB", f];
//        }
    }
    else if (size >= kb)
    {
        float f = (float) size / kb;
        strSize = [NSString stringWithFormat:@"%.2f KB", f];
//        if (f > 100)
//        {
//            strSize = [NSString stringWithFormat:@"%.0f KB", f];
//        }
//        else
//        {
//            strSize = [NSString stringWithFormat:@"%.1f KB", f];
//        }
    }
    else
    {
        strSize = [NSString stringWithFormat:@"%ld B", size];
    }
    
    return strSize;
}


@end
