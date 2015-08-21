//
//  AllClaimStatus.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/11.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllClaimStatus : JSONModel

@property (nonatomic, copy) NSString<Optional> *pending;        // 等待提交数量
@property (nonatomic, copy) NSString<Optional> *approved;       // 已提交数量
@property (nonatomic, copy) NSString<Optional> *claim;          // 已报销数量

@end
