//
//  CompanyActivityModel.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/10/31.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyActivityModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *activitytime;   // 活动过期时间
@property (nonatomic, copy) NSString<Optional> *activitytone;   // 活动标题
@property (nonatomic, copy) NSString<Optional> *activityttwo;   // 活动内容
@property (nonatomic, copy) NSString<Optional> *code;           // 邀请码
@property (nonatomic, copy) NSString<Optional> *id;             // 活动id
@property (nonatomic, copy) NSString<Optional> *flag;           // 是否有效

@end


/*
{
    "data": {
        "activitytime": "2015/12/01",
        "activitytone": "每邀请一个公司入驻，赏￥1000",
        "activityttwo": "1.邀请公司填写公司信息，发送代码到公司邮箱。\n 2.公司通过审核，邀请人即刻活的奖励￥1000.（7个工作日内）",
        "code": "xyaof8",
        "flag": 1,
        "id": 1
    },
    "message": "成功",
    "status": 1,
    "total": 0
}
*/