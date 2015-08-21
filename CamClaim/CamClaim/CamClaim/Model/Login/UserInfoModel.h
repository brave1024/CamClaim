//
//  UserInfoModel.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/5.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *name;           // 账号 <用户名 or 邮箱>
@property (nonatomic, copy) NSString<Optional> *pwd;            // 加密密码

@property (nonatomic, copy) NSString<Optional> *open_id;        // 授权回调id
@property (nonatomic, copy) NSString<Optional> *img;            // 微信，facebook，linkined 头像

@property (nonatomic, copy) NSString<Optional> *id;             // 用户id
@property (nonatomic, copy) NSString<Optional> *email;          // 邮箱
@property (nonatomic, copy) NSString<Optional> *phone;          // 手机号
@property (nonatomic, copy) NSString<Optional> *realname;       // 真实姓名
@property (nonatomic, copy) NSString<Optional> *createtime;     // 创建时间
@property (nonatomic, copy) NSString<Optional> *department;     // 所在部门
@property (nonatomic, copy) NSString<Optional> *type;           // 用户类型
@property (nonatomic, copy) NSString<Optional> *zhiwei;         // 职位
@property (nonatomic, copy) NSString<Optional> *bossstatus;     // 有无上下级 1-有上级 0-无上级

@end


/*
{
    "data": {
        "bossstatus": 1,
        "createtime": "07/17/2015 03:11:49",
        "department": null,
        "email": "",
        "id": 20,
        "img": null,
        "name": "joye",
        "open_id": null,
        "phone": "",
        "pwd": "d93a5def7511da3d0f2d171d9c344e91",
        "realname": "",
        "type": 1,
        "zhiwei": null
    },
    "message": "登陆成功",
    "status": 1,
    "total": 0
}
*/

/*
{
    "data": null,
    "message": "登陆失败",
    "status": 0,
    "total": 0
}
*/




