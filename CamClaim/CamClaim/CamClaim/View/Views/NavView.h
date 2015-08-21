//
//  NavView.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/4.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  自定义导航栏视图

#import <UIKit/UIKit.h>

@protocol NavViewDelegate <NSObject>

@optional
- (void)backAction;
- (void)moreAction;

@end


@interface NavView : UIView

@property (nonatomic, weak) IBOutlet UIButton *btnBack;
@property (nonatomic, weak) IBOutlet UIButton *btnMore;
@property (nonatomic, weak) IBOutlet UIImageView *imgLogo;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;

@property (nonatomic, assign) id<NavViewDelegate> delegate;

- (IBAction)btnBackAction;
- (IBAction)btnMoreAction;

@end
