//
//  ResponseModel.h
//  KufaLottery
//
//  Created by Xia Zhiyong on 14-9-18.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//  接口响应时返回的数据实体

#import <Foundation/Foundation.h>

@interface ResponseModel : NSObject

@property (nonatomic, assign) int status;       // 0-失败 1-成功
@property (nonatomic, copy) NSString *message;  // 提示信息
@property (nonatomic, strong) id data;          // 具体数据
@property (nonatomic, assign) int total;        //

@end
