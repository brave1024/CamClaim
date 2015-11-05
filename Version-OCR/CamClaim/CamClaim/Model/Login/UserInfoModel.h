//
//  UserInfoModel.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/5.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *name;               // 账号 <用户名 or 邮箱>
@property (nonatomic, copy) NSString<Optional> *pwd;                // 加密密码

@property (nonatomic, copy) NSString<Optional> *open_id;            // wechat授权回调id
@property (nonatomic, copy) NSString<Optional> *facebook_open_id;   // facebook
@property (nonatomic, copy) NSString<Optional> *linkeid_open_id;    // linkedin

@property (nonatomic, copy) NSString<Optional> *id;                 // 用户id
@property (nonatomic, copy) NSString<Optional> *email;              // 邮箱
@property (nonatomic, copy) NSString<Optional> *phone;              // 手机号
@property (nonatomic, copy) NSString<Optional> *realname;           // 真实姓名
@property (nonatomic, copy) NSString<Optional> *nickname;           // 昵称
@property (nonatomic, copy) NSString<Optional> *img;                // <wechat，facebook，linkined or 用户自已上传> 头像url

@property (nonatomic, copy) NSString<Optional> *company;            // 公司
@property (nonatomic, copy) NSString<Optional> *department;         // 所在部门
@property (nonatomic, copy) NSString<Optional> *zhiwei;             // 职位
@property (nonatomic, copy) NSString<Optional> *city;               // 城市
@property (nonatomic, copy) NSString<Optional> *bossstatus;         // 有无上下级 0-无上级 1-有上级

@property (nonatomic, copy) NSString<Optional> *type;               // 用户类型
@property (nonatomic, copy) NSString<Optional> *createtime;         // 创建时间

@end


/*
{
    "data": null,
    "message": "登陆失败",
    "status": 0,
    "total": 0
}
*/

/*
{
    "data": {
        "bossstatus": 0,
        "city": "武汉",
        "company": "酷控科技",
        "createtime": "2015/09/11 12:33:01",
        "department": "无线研发部",
        "email": "110381582@qq.com",
        "facebook_open_id": null,
        "id": 54,
        "img": "http://115.29.105.23:8080/img/user/IWCPZXIMRZ.png",
        "linkeid_open_id": null,
        "name": "terry",
        "nickname": "Terry",
        "open_id": null,
        "phone": "18507103285",
        "pwd": "d93a5def7511da3d0f2d171d9c344e91",
        "realname": "夏志勇",
        "type": 1,
        "zhiwei": "经理"
    },
    "message": "登陆成功",
    "status": 1,
    "total": 0
}
*/

