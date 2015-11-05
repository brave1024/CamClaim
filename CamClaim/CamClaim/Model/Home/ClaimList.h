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
@property (nonatomic, copy) NSString<Optional> *typeid;             // 类型:交通
@property (nonatomic, copy) NSString<Optional> *usetime;            // 报销时间
@property (nonatomic, copy) NSString<Optional> *forusername;        // 使用对象
@property (nonatomic, copy) NSString<Optional> *canmoney;           // 报销金额
@property (nonatomic, copy) NSString<Optional> *gmoney;             // 回款金额
@property (nonatomic, copy) NSString<Optional> *pfile;              //

//@property (nonatomic, copy) NSString<Optional> *jd;                 // ...<不再使用>
//@property (nonatomic, copy) NSString<Optional> *wd;                 // ...<不再使用>
//@property (nonatomic, copy) NSString<Optional> *statusname;         // 状态描述...<不再使用>
//@property (nonatomic, copy) NSString<Optional> *canmoneyvalue;      // 报销钱数...<不再使用>

// Address
@property (nonatomic, copy) NSString<Optional> *qjd;                //
@property (nonatomic, copy) NSString<Optional> *qwd;                //
@property (nonatomic, copy) NSString<Optional> *qaddress;           //
@property (nonatomic, copy) NSString<Optional> *zjd;                //
@property (nonatomic, copy) NSString<Optional> *zwd;                //
@property (nonatomic, copy) NSString<Optional> *zaddress;           //

@property (nonatomic, copy) NSString<Optional> *cartype;            //
@property (nonatomic, copy) NSString<Optional> *clientcompany;      //
@property (nonatomic, copy) NSString<Optional> *days;               //
@property (nonatomic, copy) NSString<Optional> *eatway;             //
@property (nonatomic, copy) NSString<Optional> *imgurl;             //
@property (nonatomic, copy) NSString<Optional> *store;              //
@property (nonatomic, copy) NSString<Optional> *usercompany;        //
@property (nonatomic, copy) NSString<Optional> *usingname;          //


// 月报表新增
@property (nonatomic, copy) NSString<Optional> *jiyu;               // 结余金额
@property (nonatomic, copy) NSString<Optional> *message;            //

@end



@interface ClaimList : JSONModel

@property (nonatomic, strong) NSArray<ClaimItem, Optional> *claimList;

@end


/*
{
    "canmoney": "1685.00",
    "cartype": null,
    "clientcompany": null,
    "days": 0,
    "eatway": null,
    "forusername": "夏志勇",
    "gmoney": "0",
    "id": 0,
    "imgurl": null,
    "jiyu": "0",
    "location": "上海",
    "message": null,
    "pfile": null,
    "qaddress": null,
    "qjd": null,
    "qwd": null,
    "status": "pending",
    "store": null,
    "typeid": "交通",
    "useinfo": "出差",
    "usercompany": null,
    "userid": 0,
    "usetime": "2015/09",
    "usingname": null,
    "zaddress": null,
    "zjd": null,
    "zwd": null
}
*/

/*
{
    "data": [
             {
                 "canmoney": "1685.00",
                 "cartype": null,
                 "clientcompany": null,
                 "days": 0,
                 "eatway": null,
                 "forusername": "夏志勇",
                 "gmoney": "0",
                 "id": 0,
                 "imgurl": null,
                 "jiyu": "0",
                 "location": "上海",
                 "message": null,
                 "pfile": null,
                 "qaddress": null,
                 "qjd": null,
                 "qwd": null,
                 "status": "pending",
                 "store": null,
                 "typeid": "交通",
                 "useinfo": "出差",
                 "usercompany": null,
                 "userid": 0,
                 "usetime": "2015/09",
                 "usingname": null,
                 "zaddress": null,
                 "zjd": null,
                 "zwd": null
             },
             {
                 "canmoney": "4968.00",
                 "cartype": null,
                 "clientcompany": null,
                 "days": 0,
                 "eatway": null,
                 "forusername": "夏志勇",
                 "gmoney": "0",
                 "id": 0,
                 "imgurl": null,
                 "jiyu": "0",
                 "location": "武汉",
                 "message": null,
                 "pfile": null,
                 "qaddress": null,
                 "qjd": null,
                 "qwd": null,
                 "status": "pending",
                 "store": null,
                 "typeid": "交通",
                 "useinfo": "出差香港",
                 "usercompany": null,
                 "userid": 0,
                 "usetime": "2015/09",
                 "usingname": null,
                 "zaddress": null,
                 "zjd": null,
                 "zwd": null
             },
             {
                 "canmoney": "2682.00",
                 "cartype": null,
                 "clientcompany": null,
                 "days": 0,
                 "eatway": null,
                 "forusername": "夏志勇",
                 "gmoney": "0",
                 "id": 0,
                 "imgurl": null,
                 "jiyu": "0",
                 "location": "香港",
                 "message": null,
                 "pfile": null,
                 "qaddress": null,
                 "qjd": null,
                 "qwd": null,
                 "status": "pending",
                 "store": null,
                 "typeid": "住宿",
                 "useinfo": "住宿",
                 "usercompany": null,
                 "userid": 0,
                 "usetime": "2015/09",
                 "usingname": null,
                 "zaddress": null,
                 "zjd": null,
                 "zwd": null
             },
             {
                 "canmoney": "258.00",
                 "cartype": null,
                 "clientcompany": null,
                 "days": 0,
                 "eatway": null,
                 "forusername": "夏志勇",
                 "gmoney": "0",
                 "id": 0,
                 "imgurl": null,
                 "jiyu": "0",
                 "location": "武汉",
                 "message": null,
                 "pfile": null,
                 "qaddress": null,
                 "qjd": null,
                 "qwd": null,
                 "status": "pending",
                 "store": null,
                 "typeid": "膳食",
                 "useinfo": "餐饮",
                 "usercompany": null,
                 "userid": 0,
                 "usetime": "2015/09",
                 "usingname": null,
                 "zaddress": null,
                 "zjd": null,
                 "zwd": null
             },
             {
                 "canmoney": "5806.00",
                 "cartype": null,
                 "clientcompany": null,
                 "days": 0,
                 "eatway": null,
                 "forusername": "夏志勇",
                 "gmoney": "0",
                 "id": 0,
                 "imgurl": null,
                 "jiyu": "0",
                 "location": "武汉",
                 "message": null,
                 "pfile": null,
                 "qaddress": null,
                 "qjd": null,
                 "qwd": null,
                 "status": "pending",
                 "store": null,
                 "typeid": "文儀用品",
                 "useinfo": "中秋晚会表演道具",
                 "usercompany": null,
                 "userid": 0,
                 "usetime": "2015/09",
                 "usingname": null,
                 "zaddress": null,
                 "zjd": null,
                 "zwd": null
             },
             {
                 "canmoney": "806.00",
                 "cartype": null,
                 "clientcompany": null,
                 "days": 0,
                 "eatway": null,
                 "forusername": "夏志勇",
                 "gmoney": "0",
                 "id": 0,
                 "imgurl": null,
                 "jiyu": "0",
                 "location": "武汉",
                 "message": null,
                 "pfile": null,
                 "qaddress": null,
                 "qjd": null,
                 "qwd": null,
                 "status": "pending",
                 "store": null,
                 "typeid": "杂项开支",
                 "useinfo": "其他费用",
                 "usercompany": null,
                 "userid": 0,
                 "usetime": "2015/09",
                 "usingname": null,
                 "zaddress": null,
                 "zjd": null,
                 "zwd": null
             },
             {
                 "canmoney": "672.00",
                 "cartype": null,
                 "clientcompany": null,
                 "days": 0,
                 "eatway": null,
                 "forusername": "夏志勇",
                 "gmoney": "0",
                 "id": 0,
                 "imgurl": null,
                 "jiyu": "0",
                 "location": "武汉",
                 "message": null,
                 "pfile": null,
                 "qaddress": null,
                 "qjd": null,
                 "qwd": null,
                 "status": "pending",
                 "store": null,
                 "typeid": null,
                 "useinfo": "出差办公车费",
                 "usercompany": null,
                 "userid": 0,
                 "usetime": "2015/09",
                 "usingname": null,
                 "zaddress": null,
                 "zjd": null,
                 "zwd": null
             },
             {
                 "canmoney": "6802.00",
                 "cartype": null,
                 "clientcompany": null,
                 "days": 0,
                 "eatway": null,
                 "forusername": "夏志勇",
                 "gmoney": "0",
                 "id": 0,
                 "imgurl": null,
                 "jiyu": "0",
                 "location": "北京",
                 "message": null,
                 "pfile": null,
                 "qaddress": null,
                 "qjd": null,
                 "qwd": null,
                 "status": "pending",
                 "store": null,
                 "typeid": "工具",
                 "useinfo": "办公用品",
                 "usercompany": null,
                 "userid": 0,
                 "usetime": "2015/09",
                 "usingname": null,
                 "zaddress": null,
                 "zjd": null,
                 "zwd": null
             },
             {
                 "canmoney": "5880.00",
                 "cartype": null,
                 "clientcompany": null,
                 "days": 0,
                 "eatway": null,
                 "forusername": "夏志勇",
                 "gmoney": "0",
                 "id": 0,
                 "imgurl": null,
                 "jiyu": "0",
                 "location": "武汉",
                 "message": null,
                 "pfile": null,
                 "qaddress": null,
                 "qjd": null,
                 "qwd": null,
                 "status": "pending",
                 "store": null,
                 "typeid": "禮物",
                 "useinfo": "中秋礼品",
                 "usercompany": null,
                 "userid": 0,
                 "usetime": "2015/09",
                 "usingname": null,
                 "zaddress": null,
                 "zjd": null,
                 "zwd": null
             },
             {
                 "canmoney": "29559.00",
                 "cartype": null,
                 "clientcompany": null,
                 "days": 0,
                 "eatway": null,
                 "forusername": "",
                 "gmoney": "0",
                 "id": 0,
                 "imgurl": null,
                 "jiyu": "-29559.00",
                 "location": "",
                 "message": null,
                 "pfile": null,
                 "qaddress": null,
                 "qjd": null,
                 "qwd": null,
                 "status": null,
                 "store": null,
                 "typeid": "",
                 "useinfo": "",
                 "usercompany": null,
                 "userid": 0,
                 "usetime": "",
                 "usingname": null,
                 "zaddress": null,
                 "zjd": null,
                 "zwd": null
             }
             ],
    "message": "获取数据成功",
    "status": 1,
    "total": 0
}
*/


// 1.首界面5项发票记录
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



// 2.月报表记录
/*
{
    "data": [
             {
                 "canmoney": "0",
                 "forusername": "lili",
                 "gmoney": "0",
                 "id": 0,
                 "jd": null,
                 "jiyu": "0",
                 "location": "沙田",
                 "message": null,
                 "pfile": null,
                 "status": null,
                 "typeid": "餐飲費",
                 "useinfo": "eat",
                 "userid": 0,
                 "usetime": "2015/07",
                 "wd": null
             },
             {
                 "canmoney": "0",
                 "forusername": "lili",
                 "gmoney": "0",
                 "id": 0,
                 "jd": null,
                 "jiyu": "0",
                 "location": "沙田",
                 "message": null,
                 "pfile": null,
                 "status": null,
                 "typeid": "餐飲費",
                 "useinfo": "using eat",
                 "userid": 0,
                 "usetime": "2015/07",
                 "wd": null
             },
             {
                 "canmoney": "0",
                 "forusername": "asdasd",
                 "gmoney": "0",
                 "id": 0,
                 "jd": null,
                 "jiyu": "0",
                 "location": "dasda",
                 "message": null,
                 "pfile": null,
                 "status": null,
                 "typeid": "交通費",
                 "useinfo": "dasdas",
                 "userid": 0,
                 "usetime": "2015/07",
                 "wd": null
             },
             {
                 "canmoney": "0",
                 "forusername": "",
                 "gmoney": "0",
                 "id": 0,
                 "jd": null,
                 "jiyu": "0",
                 "location": "",
                 "message": null,
                 "pfile": null,
                 "status": null,
                 "typeid": "",
                 "useinfo": "",
                 "userid": 0,
                 "usetime": "",
                 "wd": null
             }
             ],
    "message": "获取数据成功",
    "status": 1,
    "total": 0
}
*/



// 3.发票记录
/*
{
    "data": [
             {
                 "canmoney": "0",
                 "forusername": "lili",
                 "gmoney": "0",
                 "id": 0,
                 "jd": null,
                 "jiyu": "0",
                 "location": "沙田",
                 "message": null,
                 "pfile": null,
                 "status": null,
                 "typeid": "餐飲費",
                 "useinfo": "eat",
                 "userid": 0,
                 "usetime": "2015/07",
                 "wd": null
             },
             {
                 "canmoney": "0",
                 "forusername": "lili",
                 "gmoney": "0",
                 "id": 0,
                 "jd": null,
                 "jiyu": "0",
                 "location": "沙田",
                 "message": null,
                 "pfile": null,
                 "status": null,
                 "typeid": "餐飲費",
                 "useinfo": "using eat",
                 "userid": 0,
                 "usetime": "2015/07",
                 "wd": null
             },
             {
                 "canmoney": "0",
                 "forusername": "asdasd",
                 "gmoney": "0",
                 "id": 0,
                 "jd": null,
                 "jiyu": "0",
                 "location": "dasda",
                 "message": null,
                 "pfile": null,
                 "status": null,
                 "typeid": "交通費",
                 "useinfo": "dasdas",
                 "userid": 0,
                 "usetime": "2015/07",
                 "wd": null
             }
             ],
    "message": "获取数据成功",
    "status": 1,
    "total": 0
}
*/

