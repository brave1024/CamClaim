//
//  ClaimNewModel.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  用于新增发票实体

#import <Foundation/Foundation.h>

@interface ClaimNewModel : NSObject

@property (nonatomic, copy) NSString<Optional> *client;         // 发票目标人物...<不再使用>
@property (nonatomic, copy) NSString<Optional> *claimType;      // 发票类型...<不再使用>
@property (nonatomic, copy) NSString<Optional> *location;       // 地点...<不再使用>
@property (nonatomic, copy) NSString<Optional> *longitude;      // 经度...<不再使用>
@property (nonatomic, copy) NSString<Optional> *latitude;       // 纬度...<不再使用>

@property (nonatomic, copy) NSString<Optional> *userid;         // 用户id
@property (nonatomic, copy) NSString<Optional> *money;          // 金额
@property (nonatomic, copy) NSString<Optional> *time;           // 日期
@property (nonatomic, copy) NSString<Optional> *purpose;        // 发票事由
@property (nonatomic, copy) NSString<Optional> *company;        // 用户公司id

// 新增字段
@property (nonatomic, copy) NSString<Optional> *typeid_;        // 发票类型
@property (nonatomic, copy) NSString<Optional> *qjd;            // 起点经度
@property (nonatomic, copy) NSString<Optional> *qwd;            // 起点纬度
@property (nonatomic, copy) NSString<Optional> *qaddress;       // 起点地址
@property (nonatomic, copy) NSString<Optional> *zjd;            // 终点经度
@property (nonatomic, copy) NSString<Optional> *zwd;            // 终点纬度
@property (nonatomic, copy) NSString<Optional> *zaddress;       // 终点地址
@property (nonatomic, copy) NSString<Optional> *cartype;        // 交通工具类型
@property (nonatomic, copy) NSString<Optional> *usercompany;    // 用户公司名称
@property (nonatomic, copy) NSString<Optional> *imgurl;         // 图片名称
@property (nonatomic, copy) NSString<Optional> *store;          // 酒店名称 or 餐厅名称 or 商店名称
@property (nonatomic, copy) NSString<Optional> *days;           // 天数
@property (nonatomic, copy) NSString<Optional> *eatway;         // 早餐 or 午餐 or 晚餐
@property (nonatomic, copy) NSString<Optional> *clientcompany;  // 客户公司名称
@property (nonatomic, copy) NSString<Optional> *usingname;      // 项目名称
@property (nonatomic, copy) NSString<Optional> *status;         // 报销状态

@end
