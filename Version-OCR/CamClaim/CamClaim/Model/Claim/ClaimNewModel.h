//
//  ClaimNewModel.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  用于新增发票实体

#import <Foundation/Foundation.h>

@interface ClaimNewModel : NSObject

@property (nonatomic, copy) NSString<Optional> *client;         // 发票目标人物
@property (nonatomic, copy) NSString<Optional> *purpose;        // 发票事由
@property (nonatomic, copy) NSString<Optional> *money;          // 金额
@property (nonatomic, copy) NSString<Optional> *time;           // 日期
@property (nonatomic, copy) NSString<Optional> *claimType;      // 发票类型
@property (nonatomic, copy) NSString<Optional> *company;        // 公司
@property (nonatomic, copy) NSString<Optional> *location;       // 地点

@property (nonatomic, copy) NSString<Optional> *longitude;      // 经度
@property (nonatomic, copy) NSString<Optional> *latitude;       // 纬度
@property (nonatomic, copy) NSString<Optional> *userid;         // 用户id

@end
