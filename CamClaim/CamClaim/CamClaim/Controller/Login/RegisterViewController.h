//
//  RegisterViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/4.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  注册

#import <UIKit/UIKit.h>

@interface RegisterViewController : BaseViewController

// scrollview width
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewWidth;
// bgviewForInput width
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBarWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBarWidth_1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBarWidth_2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBarWidth_3;
// btnRegister width
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnRegisterWidth;
// textfield width
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtfieldWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtfieldWidth_1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtfieldWidth_2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtfieldWidth_3;

@end