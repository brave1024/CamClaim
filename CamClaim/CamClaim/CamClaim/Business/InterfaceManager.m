//
//  InterfaceManager.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15-8-5.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import "InterfaceManager.h"

@implementation InterfaceManager


#pragma mark ---------
#pragma mark =========================== Login & Register ===========================

/**
 *	@brief	用户注册
 *
 *	@param 	account 	账号(用户手动输入的邮箱地址)
 *	@param 	psw 	密码
 *	@param 	name 	姓名
 *	@param 	phone 	电话
 *	@param 	completion 	回调block
 */
+ (void)userRegister:(NSString *)account
            password:(NSString *)psw
                name:(NSString *)name
               phone:(NSString *)phone
          completion:(interfaceManagerBlock)completion
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:account forKey:@"email"];
    [dic setObject:psw forKey:@"pwd"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:phone forKey:@"phone"];
    
    LogDebug(@"request:%@", dic);
    
    [WebService startPostRequest:API_USER_REGISTER body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
        
        // 成功
        LogDebug(@"<success>:%@", operation.responseString);
        
        completion(YES, @"注册成功", response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
        
        // 失败
        LogDebug(@"<failed>:%@", [error description]);
        
        if (responseError != nil)
        {
            completion(NO, responseError.Message, responseError);
        }
        else
        {
            completion(NO, @"注册失败", nil);
        }
        
    }];
}

/**
 *	@brief	用户登录
 *
 *	@param 	account 	邮箱(用户手动注册时输入的邮箱地址，作为手动登录时的账号)
 *	@param 	psw 	密码
 *	@param 	completion 	回调block
 */
+ (void)userLogin:(NSString *)account
         password:(NSString *)psw
       completion:(interfaceManagerBlock)completion
{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:account forKey:@"email"];
//    [dic setObject:psw forKey:@"pwd"];
    
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:account, @"email", psw, @"pwd", nil];
    NSDictionary *dic = @{@"email":account, @"pwd":psw};
    LogDebug(@"request:%@", dic);
    
    [WebService startPostRequest:API_USER_LOGIN body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
        
        // 成功
        LogDebug(@"<success>:%@", operation.responseString);
        
        completion(YES, @"登录成功", response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
        
        // 失败
        LogDebug(@"<failed>:%@", [error description]);
        
        if (responseError != nil)
        {
            completion(NO, responseError.Message, responseError);
        }
        else
        {
            completion(NO, @"登录失败", nil);
        }
        
    }];
}

/**
 *	@brief	用户授权登录<获取用户id与加密密码>
 *
 *	@param 	openid 	第三方授权成功后获取到的用户id
 *	@param 	pic 	用户头像
 *	@param 	completion 	回调block
 */
+ (void)userAuthLogin:(NSString *)openid
                  pic:(NSString *)pic
           completion:(interfaceManagerBlock)completion
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:openid forKey:@"openid"];
    [dic setObject:pic forKey:@"pic"];
    
    LogDebug(@"request:%@", dic);
    
    [WebService startPostRequest:API_USER_AUTHLOGIN body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
        
        // 成功
        LogDebug(@"<success>:%@", operation.responseString);
        
        completion(YES, @"登录成功", response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
        
        // 失败
        LogDebug(@"<failed>:%@", [error description]);
        
        if (responseError != nil)
        {
            completion(NO, responseError.Message, responseError);
        }
        else
        {
            completion(NO, @"登录失败", nil);
        }
        
    }];
}

/**
 *	@brief	用户在第三方平台授权成功后，将相应的userid传给后台，后台自动生成一个账号密码(后台自动注册)；app在下次启动时使用后台返回的账号与加密密码进行自动登录操作。
 *
 *	@param 	account 	后台随机生成的用户账号(非邮箱)
 *	@param 	psw 	后台随机生成的加密密码
 *	@param 	completion 	回调block
 */
+ (void)userAutoAuthLogin:(NSString *)account
                 password:(NSString *)psw
               completion:(interfaceManagerBlock)completion
{
    NSDictionary *dic = @{@"email":account, @"pwd":psw};
    LogDebug(@"request:%@", dic);
    
    [WebService startPostRequest:API_USER_AUTOAUTHLOGIN body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
        
        // 成功
        LogDebug(@"<success>:%@", operation.responseString);
        
        completion(YES, @"登录成功", response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
        
        // 失败
        LogDebug(@"<failed>:%@", [error description]);
        
        if (responseError != nil)
        {
            completion(NO, responseError.Message, responseError);
        }
        else
        {
            completion(NO, @"登录失败", nil);
        }
        
    }];
}

/**
 *	@brief	获取当前用户最近五项报销记录
 *
 *	@param 	completion 	回调block
 */
+ (void)getUserNewFiveClaimList:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_GETNEWFIVELIST body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"获取数据成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"获取数据失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}

/**
 *	@brief	获取用户所有报销状态数量
 *
 *	@param 	completion 	回调block
 */
+ (void)getUserAllClaimStatus:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_GETALLSTATUS body:dic returnClass:[AllClaimStatus class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"获取数据成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"获取数据失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}

/**
 *	@brief	按年月查询报表记录
 *
 *	@param 	month 	年月
 *	@param 	completion  回调block
 */
+ (void)getUserReportByMonth:(NSString *)month
                  completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userId":userId, @"datetime":month};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_GETREPORTBYMONTH body:dic returnClass:[AllClaimStatus class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"获取数据成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"获取数据失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}

/**
 *	@brief	按年月查询发票记录
 *
 *	@param 	month 	年月
 *	@param 	completion  回调block
 */
+ (void)getUserClaimByMonth:(NSString *)month
                 completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userId":userId, @"datetime":month};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_GETCLAIMBYMONTH body:dic returnClass:[AllClaimStatus class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"获取数据成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"获取数据失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}




@end
