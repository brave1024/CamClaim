//
//  RequestModel.h
//  KufaLottery
//
//  Created by Xia Zhiyong on 14-9-18.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//  接口请求时需传递的参数实体--<基类>

#import <Foundation/Foundation.h>

@interface RequestModel : NSObject

@property (nonatomic, assign) NSInteger PageSize;     // 每页条数
@property (nonatomic, assign) NSInteger PageIndex;    // 页面号

@end
