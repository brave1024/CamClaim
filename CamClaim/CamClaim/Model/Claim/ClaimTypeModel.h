//
//  ClaimTypeModel.h
//  CamClaim
//
//  Created by 夏志勇 on 15/9/11.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  返回的发票实体

#import <Foundation/Foundation.h>

@interface ClaimTypeModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *id;             // id
@property (nonatomic, copy) NSString<Optional> *status;         // 状态
@property (nonatomic, copy) NSString<Optional> *typename_;      // 名称
@property (nonatomic, copy) NSString<Optional> *userid;         // 用户id

@end


/*
{
    "data": [
             {
                 "id": 12,
                 "status": 0,
                 "typename": "餐飲費",
                 "userid": 10
             },
             {
                 "id": 13,
                 "status": 0,
                 "typename": "交通費",
                 "userid": 10
             },
             {
                 "id": 14,
                 "status": 0,
                 "typename": "服裝費",
                 "userid": 10
             },
             {
                 "id": 15,
                 "status": 0,
                 "typename": "住宿費",
                 "userid": 10
             },
             {
                 "id": 16,
                 "status": 0,
                 "typename": "其他支出",
                 "userid": 10
             }
             ],
    "message": "登陆成功",
    "status": 1,
    "total": 0
}
*/