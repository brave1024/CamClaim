//
//  UserBaseInfo.h
//  CamClaim
//
//  Created by 夏志勇 on 15/9/11.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  修改/更新个人信息时使用到的实体

#import <Foundation/Foundation.h>

@interface UserBaseInfo : NSObject

// 目前需要填写的
@property (nonatomic, copy) NSString *realname;       // 姓名
@property (nonatomic, copy) NSString *nickname;       // 昵称
@property (nonatomic, copy) NSString *email;          // 邮箱
@property (nonatomic, copy) NSString *phone;          // 手机号
@property (nonatomic, copy) NSString *company;        // 公司
@property (nonatomic, copy) NSString *department;     // 部门
@property (nonatomic, copy) NSString *position;       // 职位
@property (nonatomic, copy) NSString *city;           // 城市

@end
