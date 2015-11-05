//
//  UIView+Utils.m
//  KufaLottery
//
//  Created by Xia Zhiyong on 14-12-10.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)


- (void)setOriginX:(CGFloat)originX
{
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (void)setOriginY:(CGFloat)originY
{
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (void)setSizeWidth:(CGFloat)sizeWidth
{
    CGRect frame = self.frame;
    frame.size.width = sizeWidth;
    self.frame = frame;
}

- (CGFloat)sizeWidth
{
    return self.frame.size.width;
}

- (void)setSizeHeight:(CGFloat)sizeHeight
{
    CGRect frame = self.frame;
    frame.size.height = sizeHeight;
    self.frame = frame;
}

- (CGFloat)sizeHeight
{
    return self.frame.size.height;
}

+ (instancetype)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([[self class] class]) owner:nil options:nil] lastObject];
}

+ (instancetype)viewFromNibForDifferentDevice
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

- (void)configWithData:(id)data
{
    // need be overwrite
    LogInfo(@"This function need be overwrite by [%@]", NSStringFromClass([self class]));
}


@end
