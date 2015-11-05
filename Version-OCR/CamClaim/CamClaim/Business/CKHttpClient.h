//
//  CKHttpClient.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15-8-5.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface CKHttpClient : AFHTTPRequestOperationManager

+ (instancetype)defaultHttpClient;

/**
 *  根据接口取消请求
 */
- (void)cancelRequest:(NSString *)action;

/**
 *  取消所有请求
 */
- (void)cancelAllRequest;

@end
