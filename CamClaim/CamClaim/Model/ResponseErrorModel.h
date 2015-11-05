//
//  ResponseErrorModel.h
//  KufaLottery
//
//  Created by Xia Zhiyong on 14-10-9.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//  接口响应<失败>时返回的数据实体

#import <Foundation/Foundation.h>

@interface ResponseErrorModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *ErrorCode;
@property (nonatomic, copy) NSString<Optional> *Message;

@end

/*
{"ErrorCode":"6011811","Message":"第2次登录错误"}
*/