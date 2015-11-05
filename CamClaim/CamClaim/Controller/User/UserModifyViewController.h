//
//  UserModifyViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  修改用户信息

#import <UIKit/UIKit.h>

@interface UserModifyViewController : BaseViewController

// 判断是否为新注册用户; 若是,则在注册成功后,需要完善个人资料;
@property BOOL registerFlag;

@end
