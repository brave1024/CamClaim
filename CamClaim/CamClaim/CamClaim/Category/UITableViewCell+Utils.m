//
//  UITableViewCell+Utils.m
//  OpenOOIM
//
//  Created by Ian on 14-8-19.
//  Copyright (c) 2014年 武汉九午科技有限公司. All rights reserved.
//

#import "UITableViewCell+Utils.h"

@implementation UITableViewCell (Utils)

+ (instancetype)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([[self class] class]) owner:nil options:nil] lastObject];
}

+ (instancetype)cellFromNibForDifferentDevice
{
    // 根据不同的屏幕尺寸来读取不同的xib
    if (kScreenWidth == kWidthFor6plus)
    {
        // 6 plus
        return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([[self class] class]) owner:self options:nil] objectAtIndex:2];
    }
    else if (kScreenWidth == kWidthFor6)
    {
        // 6
        return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([[self class] class]) owner:self options:nil] objectAtIndex:1];
    }
    else
    {
        // 4 4s / 5 5s 5c
        return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([[self class] class]) owner:self options:nil] objectAtIndex:0];
    }
}

+ (instancetype)cellFromNib:(UINib *)nib
{
    // 根据不同的屏幕尺寸来读取不同的xib
    if (kScreenWidth == kWidthFor6plus)
    {
        // 6 plus
        return [[nib instantiateWithOwner:self options:nil] getObjectAtIndex:2];
        return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([[self class] class]) owner:self options:nil] objectAtIndex:2];
    }
    else if (kScreenWidth == kWidthFor6)
    {
        // 6
        return [[nib instantiateWithOwner:self options:nil] getObjectAtIndex:1];
        return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([[self class] class]) owner:self options:nil] objectAtIndex:1];
    }
    else
    {
        // 4 4s / 5 5s 5c
        return [[nib instantiateWithOwner:self options:nil] getObjectAtIndex:0];
        return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([[self class] class]) owner:self options:nil] objectAtIndex:0];
    }
}

- (void)configWithData:(id)data
{
    // need be overwrite
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}

@end
