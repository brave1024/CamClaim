//
//  NoticeInviteModel.h
//  CamClaim
//
//  Created by 夏志勇 on 15/10/19.
//  Copyright © 2015年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeInviteModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *id;             // id
@property (nonatomic, copy) NSString<Optional> *userid;         // 用户id
@property (nonatomic, copy) NSString<Optional> *companyname;    // 公司名称
@property (nonatomic, copy) NSString<Optional> *manager;        // 主管名称或邀请用户名称
@property (nonatomic, copy) NSString<Optional> *managermail;    // 主管邮箱或邀请用户邮箱
@property (nonatomic, copy) NSString<Optional> *ycode;          // 邀请码
@property (nonatomic, copy) NSString<Optional> *ytype;          // 邀请类型-1.邀请用户，2.邀请公司

@end

/*
{
    "data": [
             {
                 "companyname": "等待",
                 "id": 1,
                 "manager": "特工",
                 "managermail": "哈哈",
                 "userid": 22,
                 "ycode": "0db7n8",
                 "ytype": 2
             },
             {
                 "companyname": "等待",
                 "id": 2,
                 "manager": "特工",
                 "managermail": "哈哈",
                 "userid": 22,
                 "ycode": "0db7n8",
                 "ytype": 2
             },
             {
                 "companyname": "等待",
                 "id": 3,
                 "manager": "特工",
                 "managermail": "哈哈",
                 "userid": 22,
                 "ycode": "0db7n8",
                 "ytype": 2
             }
             ],
    "message": "登陆成功",
    "status": 1,
    "total": 0
}
*/