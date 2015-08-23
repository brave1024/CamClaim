//
//  SubmitClaimViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/18.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  添加发票界面

#import <UIKit/UIKit.h>

@interface SubmitClaimViewController : BaseViewController

// scrollview高度固定,宽度随屏幕宽度动态调整
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textfieldWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTimeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBillWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewCompanyWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnSubmitWidth;

@end
