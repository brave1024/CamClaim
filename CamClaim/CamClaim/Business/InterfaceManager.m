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
 *	@brief	用户账号与第三方平台绑定
 *
 *	@param 	openid 	第三方平台授权后返回的id
 *	@param 	pic 	第三方平台中用户的头像url
 *	@param 	type 	第三方平台类型 0-wechat 1-facebook 2-linkedin
 *	@param 	completion 	回调block
 */
+ (void)userAccountBind:(NSString *)openid
                    pic:(NSString *)pic
               withType:(int)type
             completion:(interfaceManagerBlock)completion
{
    if (type != 0 && type != 1 && type != 2)
    {
        completion(NO, @"未知平台", nil);
        return;
    }
    
    if (openid == nil)
    {
        completion(NO, @"授权失败", nil);
        return;
    }
    
    NSString *key = nil;
    if (type == 0)
    {
        key = @"openid";
    }
    else if (type == 1)
    {
        key = @"facebook_open_id";
    }
    else if (type == 2)
    {
        key = @"linkin_open_id";
    }
    
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:userId forKey:@"userid"];
        [dic setObject:openid forKey:key];
        [dic setObject:pic forKey:@"img"];
        
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_THIRDPARTBIND body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
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
    else
    {
        completion(NO, @"用户未登录", nil);
    }
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
 *	@brief	按关键字查询发票记录
 *
 *	@param 	key 	关键字
 *	@param 	completion 	回调block
 */
+ (void)getUserReportByKey:(NSString *)key
                completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userId":userId, @"searchcontent":key};
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

/**
 *	@brief	更新个人资料
 *
 *	@param 	baseInfo 	个人资料实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserBaseInfo:(UserBaseInfo *)baseInfo
                completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    //NSString *pwd = user.userInfo.pwd;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userId forKey:@"userid"];
    //[dic setObject:pwd forKey:@"pwd"];
    [dic setObject:(baseInfo.realname != nil ? baseInfo.realname : @"") forKey:@"realname"];
    [dic setObject:(baseInfo.nickname != nil ? baseInfo.nickname : @"") forKey:@"nickname"];
    [dic setObject:(baseInfo.email != nil ? baseInfo.email : @"") forKey:@"email"];
    [dic setObject:(baseInfo.phone != nil ? baseInfo.phone : @"") forKey:@"phone"];
    [dic setObject:(baseInfo.company != nil ? baseInfo.company : @"") forKey:@"company"];
    [dic setObject:(baseInfo.department != nil ? baseInfo.department : @"") forKey:@"department"];
    [dic setObject:(baseInfo.position != nil ? baseInfo.position : @"") forKey:@"zhiwei"];
    [dic setObject:(baseInfo.city != nil ? baseInfo.city : @"") forKey:@"city"];
    
    LogDebug(@"request:%@", dic);
    
    [WebService startPostRequest:API_USER_UPDATEUSERINFO body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
        
        // 成功
        LogDebug(@"<success>:%@", operation.responseString);
        
        completion(YES, @"更新成功", response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
        
        // 失败
        LogDebug(@"<failed>:%@", [error description]);
        
        if (responseError != nil)
        {
            completion(NO, responseError.Message, responseError);
        }
        else
        {
            completion(NO, @"更新失败", nil);
        }
        
    }];
}

/**
 *	@brief	修改用户密码
 *
 *	@param 	baseInfo 	新密码
 *	@param 	completion 	回调block
 */
+ (void)changeUserPassword:(NSString *)psw
                completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userId forKey:@"userid"];
    [dic setObject:psw forKey:@"pwd"];
    
    LogDebug(@"request:%@", dic);
    
    [WebService startPostRequest:API_USER_UPDATEUSERINFO body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
        
        // 成功
        LogDebug(@"<success>:%@", operation.responseString);
        
        completion(YES, @"更新成功", response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
        
        // 失败
        LogDebug(@"<failed>:%@", [error description]);
        
        if (responseError != nil)
        {
            completion(NO, responseError.Message, responseError);
        }
        else
        {
            completion(NO, @"更新失败", nil);
        }
        
    }];
}

/**
 *	@brief	获取发票类型
 *
 *	@param 	completion 	回调block
 */
+ (void)getClaimType:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_GETAPPTYPELIST body:dic returnClass:nil success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
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
 *	@brief	获取用户公司
 *
 *	@param 	completion 	回调block
 */
+ (void)getUserCompany:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_GETCOMPANYINFO body:dic returnClass:[AllClaimStatus class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
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
 *	@brief	增加公司
 *
 *	@param 	company 	公司名
 *	@param 	completion 	回调block
 */
+ (void)addUserCompany:(NSString *)company
            completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId, @"company":company};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_ADDCOMPANYINFO body:dic returnClass:[AllClaimStatus class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"新增公司成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"新增公司失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}

/**
 *	@brief	删除公司
 *
 *	@param 	companyid 	公司名
 *	@param 	completion 	回调block
 */
+ (void)deleteUserCompany:(NSString *)companyid
               completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId, @"companyid":companyid};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_DELETECOMPANYINFO body:dic returnClass:[AllClaimStatus class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"删除公司成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"删除公司失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}

/**
 *	@brief	搜索公司
 *
 *	@param 	key 	搜索公司关键字
 *	@param 	completion 	回调block
 */
+ (void)searchCompany:(NSString *)key
           completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"name":key};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_SEARCHCOMPANY body:dic returnClass:[CompanyModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"搜索公司成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"搜索公司失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}

/**
 *	@brief	增加发票
 *
 *	@param 	claim 	发票实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserNewClaim:(ClaimNewModel *)claim
                completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userId forKey:@"userid"];
    [dic setObject:(claim.client != nil ? claim.client : @"") forKey:@"client"];
    [dic setObject:(claim.purpose != nil ? claim.purpose : @"") forKey:@"using"];
    [dic setObject:(claim.money != nil ? claim.money : @"") forKey:@"money"];
    [dic setObject:(claim.time != nil ? claim.time : @"") forKey:@"time"];
    [dic setObject:(claim.claimType != nil ? claim.claimType : @"") forKey:@"typeid"];
    [dic setObject:(claim.company != nil ? claim.company : @"") forKey:@"companyid"];   // 公司id
    [dic setObject:(claim.location != nil ? claim.location : @"") forKey:@"localtion"];
    
    LogDebug(@"request:%@", dic);
    
    [WebService startPostRequest:API_USER_ADDCLAIM body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
        
        // 成功
        LogDebug(@"<success>:%@", operation.responseString);
        
        completion(YES, @"更新成功", response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
        
        // 失败
        LogDebug(@"<failed>:%@", [error description]);
        
        if (responseError != nil)
        {
            completion(NO, responseError.Message, responseError);
        }
        else
        {
            completion(NO, @"更新失败", nil);
        }
        
    }];
}

/**
 *	@brief	增加交通类发票
 *
 *	@param 	claim 	发票实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserNewClaimForTraffic:(ClaimNewModel *)claim
                          completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userId forKey:@"userid"];
    [dic setObject:(claim.money != nil ? claim.money : @"") forKey:@"money"];
    [dic setObject:(claim.time != nil ? claim.time : @"") forKey:@"time"];
    [dic setObject:(claim.typeid_ != nil ? claim.typeid_ : @"") forKey:@"typeid"];
    [dic setObject:(claim.qjd != nil ? claim.qjd : @"") forKey:@"jd"];
    [dic setObject:(claim.qwd != nil ? claim.qwd : @"") forKey:@"wd"];
    [dic setObject:(claim.qaddress != nil ? claim.qaddress : @"") forKey:@"qaddress"];
    [dic setObject:(claim.zjd != nil ? claim.zjd : @"") forKey:@"zjd"];
    [dic setObject:(claim.zwd != nil ? claim.zwd : @"") forKey:@"zwd"];
    [dic setObject:(claim.zaddress != nil ? claim.zaddress : @"") forKey:@"zaddress"];
    [dic setObject:(claim.cartype != nil ? claim.cartype : @"") forKey:@"cartype"];
    [dic setObject:(claim.company != nil ? claim.company : @"") forKey:@"companyid"];
    [dic setObject:(claim.usercompany != nil ? claim.usercompany : @"") forKey:@"usercompany"];
    [dic setObject:(claim.imgurl != nil ? claim.imgurl : @"") forKey:@"imgurl"];
    [dic setObject:(claim.status != nil ? claim.status : @"") forKey:@"status"];
    
    [dic setObject:@"" forKey:@"client"];
    [dic setObject:@"" forKey:@"using"];
    [dic setObject:@"" forKey:@"localtion"];
    [dic setObject:@"" forKey:@"remark"];
    [dic setObject:@"" forKey:@"store"];
    [dic setObject:@"0" forKey:@"days"];
    [dic setObject:@"" forKey:@"eatway"];
    [dic setObject:@"" forKey:@"clientcompany"];
    [dic setObject:@"" forKey:@"usingname"];
    
    LogDebug(@"request:%@", dic);
    
    [WebService startPostRequest:API_USER_ADDCLAIM body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
        
        // 成功
        LogDebug(@"<success>:%@", operation.responseString);
        
        completion(YES, @"更新成功", response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
        
        // 失败
        LogDebug(@"<failed>:%@", [error description]);
        
        if (responseError != nil)
        {
            completion(NO, responseError.Message, responseError);
        }
        else
        {
            completion(NO, @"更新失败", nil);
        }
        
    }];
}

/**
 *	@brief	增加住宿类发票
 *
 *	@param 	claim 	发票实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserNewClaimForHotel:(ClaimNewModel *)claim
                        completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userId forKey:@"userid"];
    [dic setObject:(claim.money != nil ? claim.money : @"") forKey:@"money"];
    [dic setObject:(claim.time != nil ? claim.time : @"") forKey:@"time"];
    [dic setObject:(claim.typeid_ != nil ? claim.typeid_ : @"") forKey:@"typeid"];
    [dic setObject:(claim.qjd != nil ? claim.qjd : @"") forKey:@"jd"];
    [dic setObject:(claim.qwd != nil ? claim.qwd : @"") forKey:@"wd"];
    [dic setObject:(claim.qaddress != nil ? claim.qaddress : @"") forKey:@"qaddress"];
    [dic setObject:(claim.store != nil ? claim.store : @"") forKey:@"store"];
    [dic setObject:(claim.purpose != nil ? claim.purpose : @"") forKey:@"using"];
    [dic setObject:(claim.days != nil ? claim.days : @"") forKey:@"days"];
    [dic setObject:(claim.company != nil ? claim.company : @"") forKey:@"companyid"];
    [dic setObject:(claim.usercompany != nil ? claim.usercompany : @"") forKey:@"usercompany"];
    [dic setObject:(claim.imgurl != nil ? claim.imgurl : @"") forKey:@"imgurl"];
    [dic setObject:(claim.status != nil ? claim.status : @"") forKey:@"status"];
    
    [dic setObject:@"" forKey:@"zjd"];
    [dic setObject:@"" forKey:@"zwd"];
    [dic setObject:@"" forKey:@"zaddress"];
    [dic setObject:@"" forKey:@"cartype"];
    [dic setObject:@"" forKey:@"client"];
    [dic setObject:@"" forKey:@"localtion"];
    [dic setObject:@"" forKey:@"remark"];
    [dic setObject:@"" forKey:@"eatway"];
    [dic setObject:@"" forKey:@"clientcompany"];
    [dic setObject:@"" forKey:@"usingname"];
    
    LogDebug(@"request:%@", dic);
    
    [WebService startPostRequest:API_USER_ADDCLAIM body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
        
        // 成功
        LogDebug(@"<success>:%@", operation.responseString);
        
        completion(YES, @"更新成功", response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
        
        // 失败
        LogDebug(@"<failed>:%@", [error description]);
        
        if (responseError != nil)
        {
            completion(NO, responseError.Message, responseError);
        }
        else
        {
            completion(NO, @"更新失败", nil);
        }
        
    }];
}

/**
 *	@brief	增加膳食类发票
 *
 *	@param 	claim 	发票实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserNewClaimForFood:(ClaimNewModel *)claim
                       completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userId forKey:@"userid"];
    [dic setObject:(claim.money != nil ? claim.money : @"") forKey:@"money"];
    [dic setObject:(claim.time != nil ? claim.time : @"") forKey:@"time"];
    [dic setObject:(claim.typeid_ != nil ? claim.typeid_ : @"") forKey:@"typeid"];
    [dic setObject:(claim.qjd != nil ? claim.qjd : @"") forKey:@"jd"];
    [dic setObject:(claim.qwd != nil ? claim.qwd : @"") forKey:@"wd"];
    [dic setObject:(claim.qaddress != nil ? claim.qaddress : @"") forKey:@"qaddress"];
    [dic setObject:(claim.store != nil ? claim.store : @"") forKey:@"store"];
    [dic setObject:(claim.eatway != nil ? claim.eatway : @"") forKey:@"eatway"];
    [dic setObject:(claim.clientcompany != nil ? claim.clientcompany : @"") forKey:@"clientcompany"];
    [dic setObject:(claim.company != nil ? claim.company : @"") forKey:@"companyid"];
    [dic setObject:(claim.usercompany != nil ? claim.usercompany : @"") forKey:@"usercompany"];
    [dic setObject:(claim.imgurl != nil ? claim.imgurl : @"") forKey:@"imgurl"];
    [dic setObject:(claim.status != nil ? claim.status : @"") forKey:@"status"];
    
    [dic setObject:@"" forKey:@"zjd"];
    [dic setObject:@"" forKey:@"zwd"];
    [dic setObject:@"" forKey:@"zaddress"];
    [dic setObject:@"" forKey:@"cartype"];
    [dic setObject:@"" forKey:@"client"];
    [dic setObject:@"" forKey:@"using"];
    [dic setObject:@"" forKey:@"localtion"];
    [dic setObject:@"" forKey:@"remark"];
    [dic setObject:@"0" forKey:@"days"];
    [dic setObject:@"" forKey:@"usingname"];
    
    LogDebug(@"request:%@", dic);
    
    [WebService startPostRequest:API_USER_ADDCLAIM body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
        
        // 成功
        LogDebug(@"<success>:%@", operation.responseString);
        
        completion(YES, @"更新成功", response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
        
        // 失败
        LogDebug(@"<failed>:%@", [error description]);
        
        if (responseError != nil)
        {
            completion(NO, responseError.Message, responseError);
        }
        else
        {
            completion(NO, @"更新失败", nil);
        }
        
    }];
}

/**
 *	@brief	增加其它类发票
 *
 *	@param 	claim 	发票实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserNewClaimForOthers:(ClaimNewModel *)claim
                         completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userId forKey:@"userid"];
    [dic setObject:(claim.money != nil ? claim.money : @"") forKey:@"money"];
    [dic setObject:(claim.time != nil ? claim.time : @"") forKey:@"time"];
    [dic setObject:(claim.typeid_ != nil ? claim.typeid_ : @"") forKey:@"typeid"];
    [dic setObject:(claim.qjd != nil ? claim.qjd : @"") forKey:@"jd"];
    [dic setObject:(claim.qwd != nil ? claim.qwd : @"") forKey:@"wd"];
    [dic setObject:(claim.qaddress != nil ? claim.qaddress : @"") forKey:@"qaddress"];
    [dic setObject:(claim.store != nil ? claim.store : @"") forKey:@"store"];
    [dic setObject:(claim.purpose != nil ? claim.purpose : @"") forKey:@"using"];
    [dic setObject:(claim.usingname != nil ? claim.usingname : @"") forKey:@"usingname"];
    [dic setObject:(claim.company != nil ? claim.company : @"") forKey:@"companyid"];
    [dic setObject:(claim.usercompany != nil ? claim.usercompany : @"") forKey:@"usercompany"];
    [dic setObject:(claim.imgurl != nil ? claim.imgurl : @"") forKey:@"imgurl"];
    [dic setObject:(claim.status != nil ? claim.status : @"") forKey:@"status"];
    
    [dic setObject:@"" forKey:@"zjd"];
    [dic setObject:@"" forKey:@"zwd"];
    [dic setObject:@"" forKey:@"zaddress"];
    [dic setObject:@"" forKey:@"cartype"];
    [dic setObject:@"" forKey:@"client"];
    [dic setObject:@"" forKey:@"localtion"];
    [dic setObject:@"" forKey:@"remark"];
    [dic setObject:@"0" forKey:@"days"];
    [dic setObject:@"" forKey:@"eatway"];
    [dic setObject:@"" forKey:@"clientcompany"];
    
    LogDebug(@"request:%@", dic);
    
    [WebService startPostRequest:API_USER_ADDCLAIM body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
        
        // 成功
        LogDebug(@"<success>:%@", operation.responseString);
        
        completion(YES, @"更新成功", response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
        
        // 失败
        LogDebug(@"<failed>:%@", [error description]);
        
        if (responseError != nil)
        {
            completion(NO, responseError.Message, responseError);
        }
        else
        {
            completion(NO, @"更新失败", nil);
        }
        
    }];
}

/**
 *	@brief	根据类型查找发票
 *
 *	@param 	type 	发票类型 0-pending, 1-cancel, 2-approved, 3-claim
 *	@param 	completion 	回调block
 */
+ (void)getUserClaimByType:(NSString *)type
                completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId, @"status":type};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_GETREPORTBYTYPE body:dic returnClass:[AllClaimStatus class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
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
 *	@brief	上传用户头像
 *
 *	@param 	type 	image头像的base64编码字符串
 *	@param 	completion 	回调block
 */
+ (void)updateUserImage:(NSString *)img
             completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId, @"img":img};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_UPDATEUSERIMG body:dic returnClass:[UserInfoModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"上传用户头像成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"上传用户头像失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}

/**
 *	@brief	加入公司
 *
 *	@param 	companyid 	公司id
 *	@param 	email 	用户邮箱
 *	@param 	phone 	用户手机号
 *	@param 	userNumber 	用户在公司的员工号
 *	@param 	completion  回调block
 */
+ (void)userJoinCompany:(NSString *)companyid
              withEmail:(NSString *)email
               andphone:(NSString *)phone
          andUserNumber:(NSString *)userNumber
             completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId, @"companyid":companyid, @"email":email, @"iphone":phone, @"usernumber":userNumber};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_JOINCOMPANY body:dic returnClass:[AllClaimStatus class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"加入公司成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"加入公司失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}

/**
 *	@brief	加入公司
 *
 *	@param 	companyid 	公司id
 *	@param 	completion 	回调block
 */
+ (void)userJoinCompany:(NSString *)companyid
             completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId, @"companyid":companyid};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_JOINCOMPANY body:dic returnClass:nil success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"申请加入公司成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"申请加入公司失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}

/**
 *	@brief	上传图片ocr信息
 *
 *	@param 	imgData 	图片base64字符串
 *	@param 	imgText 	图片ocr结果
 *	@param 	completion 	回调block
 */
+ (void)userUploadOCRImage:(NSString *)imgData
             withImageData:(NSString *)imgText
                completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId, @"imgtext":imgText, @"imgdate":imgData};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_UPDATEOCRINFO body:dic returnClass:[AllClaimStatus class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"上传ocr结果成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"上传ocr结果失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}

/**
 *	@brief	获取个人邀请记录
 *
 *	@param 	completion 	回调block
 */
+ (void)getUserInviteRecord:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_INVITERECORD body:dic returnClass:[NoticeInviteModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
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
 *	@brief	获取个人邀请公司相关活动信息
 *
 *	@param 	completion 	回调block
 */
+ (void)getUserInviteCompanyInfo:(interfaceManagerBlock)completion;
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_INVITECOMPANYFORCODE body:dic returnClass:[CompanyActivityModel class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
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
 *	@brief	个人邀请公司
 *
 *	@param 	company 	公司名称
 *	@param 	name 	公司主管姓名
 *	@param 	email 	公司主管邮箱
 *	@param 	code 	邀请码
 *	@param 	completion 	回调block
 */
+ (void)userInviteCompany:(NSString *)company
              withManager:(NSString *)name
          andManagerEmail:(NSString *)email
                  andCode:(NSString *)code
               completion:(interfaceManagerBlock)completion
{
    UserManager *user = [UserManager sharedInstance];
    NSString *userId = user.userInfo.id;
    
    if (userId != nil && userId.length > 0)
    {
        NSDictionary *dic = @{@"userid":userId, @"companyname":company, @"manager":name, @"email":email, @"code":code};
        LogDebug(@"request:%@", dic);
        
        [WebService startPostRequest:API_USER_INVITECOMPANY body:dic returnClass:[AllClaimStatus class] success:^(AFHTTPRequestOperation *operation, ResponseModel *response) {
            
            // 成功
            LogDebug(@"<success>:%@", operation.responseString);
            
            completion(YES, @"提交邀请成功", response);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError) {
            
            // 失败
            LogDebug(@"<failed>:%@", [error description]);
            
            if (responseError != nil)
            {
                completion(NO, responseError.Message, responseError);
            }
            else
            {
                completion(NO, @"提交邀请失败", nil);
            }
            
        }];
    }
    else
    {
        completion(NO, @"用户未登录", nil);
    }
}


@end
