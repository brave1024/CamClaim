//
//  UserManager.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/10.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "AllClaimStatus.h"
#import "ClaimTypeModel.h"

@interface UserManager : NSObject

// 是否已登录
@property BOOL hasLogin;

// 用户基本信息
@property (nonatomic, strong) UserInfoModel *userInfo;

// 用户所有报销状态数量
@property (nonatomic, strong) AllClaimStatus *allClaimStatus;

// 所有发票类型
@property (nonatomic, strong) NSMutableArray *arrayClaim;

// 所有公司
@property (nonatomic, strong) NSMutableArray *arrayCompany;

// 单例实例化
+ (UserManager *)sharedInstance;

@end
