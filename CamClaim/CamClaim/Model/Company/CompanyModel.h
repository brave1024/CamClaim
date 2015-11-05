//
//  CompanyModel.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *id;                 // 公司id
@property (nonatomic, copy) NSString<Optional> *userid;             // 用户id
@property (nonatomic, copy) NSString<Optional> *status;             // 状态
@property (nonatomic, copy) NSString<Optional> *companyinfo;        // 公司名
@property (nonatomic, copy) NSString<Optional> *companyuserids;     //

@end


/*
{
    "data": [
             {
                 "companyinfo": "Tencent",
                 "companyuserids": null,
                 "id": 13,
                 "status": 1,
                 "userid": 46
             }
             ],
    "message": "登陆成功",
    "status": 1,
    "total": 0
}
*/




