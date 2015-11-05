//
//  NavView.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/4.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "NavView.h"

@implementation NavView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnBackAction
{
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(backAction)] == YES
        && [self.delegate conformsToProtocol:@protocol(NavViewDelegate)] == YES)
    {
        [self.delegate backAction];
    }
}

- (IBAction)btnMoreAction
{
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(moreAction)] == YES
        && [self.delegate conformsToProtocol:@protocol(NavViewDelegate)] == YES)
    {
        [self.delegate moreAction];
    }
}


@end
