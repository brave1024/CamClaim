//
//  ClaimList.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/11.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ClaimItem <NSObject>

@end

@interface ClaimItem : JSONModel

@property (nonatomic, copy) NSString<Optional> *id;                 // id
@property (nonatomic, copy) NSString<Optional> *userid;             // 用户id
@property (nonatomic, copy) NSString<Optional> *location;           // 地点
@property (nonatomic, copy) NSString<Optional> *useinfo;            // 报销事由
@property (nonatomic, copy) NSString<Optional> *status;             // 状态: 0-pending, 1-cancel, 2-approved, 3-claim
@property (nonatomic, copy) NSString<Optional> *statusname;         // 状态描述
@property (nonatomic, copy) NSString<Optional> *canmoneyvalue;      // 报销钱数
@property (nonatomic, copy) NSString<Optional> *usetime;            // 报销时间
@property (nonatomic, copy) NSString<Optional> *forusername;        // 使用对象

@property (nonatomic, copy) NSString<Optional> *canmoney;           //
@property (nonatomic, copy) NSString<Optional> *gmoney;             //
@property (nonatomic, copy) NSString<Optional> *jd;                 //
@property (nonatomic, copy) NSString<Optional> *pfile;              //
@property (nonatomic, copy) NSString<Optional> *typeid;             //
@property (nonatomic, copy) NSString<Optional> *wd;                 //

@end



@interface ClaimList : JSONModel

@property (nonatomic, strong) NSArray<ClaimItem, Optional> *claimList;

@end



/*
{
    "data": [
             {
                 "canmoney": null,
                 "canmoneyvalue": "312.00",
                 "forusername": "asdasd",
                 "gmoney": null,
                 "id": 9,
                 "jd": null,
                 "location": "dasda",
                 "pfile": null,
                 "status": 0,
                 "statusname": "pending",
                 "typeid": 0,
                 "useinfo": null,
                 "userid": 0,
                 "usetime": "2015/07/23",
                 "wd": null
             },
             {
                 "canmoney": null,
                 "canmoneyvalue": "1000.00",
                 "forusername": "王样",
                 "gmoney": null,
                 "id": 5,
                 "jd": null,
                 "location": "上海",
                 "pfile": null,
                 "status": 0,
                 "statusname": "cancel",
                 "typeid": 0,
                 "useinfo": null,
                 "userid": 0,
                 "usetime": "2015/07/01",
                 "wd": null
             },
             {
                 "canmoney": null,
                 "canmoneyvalue": "400.00",
                 "forusername": "lili",
                 "gmoney": null,
                 "id": 6,
                 "jd": null,
                 "location": "沙田",
                 "pfile": null,
                 "status": 0,
                 "statusname": "pending",
                 "typeid": 0,
                 "useinfo": null,
                 "userid": 0,
                 "usetime": "2015/07/01",
                 "wd": null
             },
             {
                 "canmoney": null,
                 "canmoneyvalue": "1000.00",
                 "forusername": "王样",
                 "gmoney": null,
                 "id": 7,
                 "jd": null,
                 "location": "上海",
                 "pfile": null,
                 "status": 0,
                 "statusname": "cancel",
                 "typeid": 0,
                 "useinfo": null,
                 "userid": 0,
                 "usetime": "2015/07/01",
                 "wd": null
             },
             {
                 "canmoney": null,
                 "canmoneyvalue": "200.00",
                 "forusername": "lili",
                 "gmoney": null,
                 "id": 8,
                 "jd": null,
                 "location": "沙田",
                 "pfile": null,
                 "status": 0,
                 "statusname": "pending",
                 "typeid": 0,
                 "useinfo": null,
                 "userid": 0,
                 "usetime": "2015/07/01",
                 "wd": null
             }
             ],
    "message": "获取成功",
    "status": 1,
    "total": 0
}
*/