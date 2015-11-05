//
//  InterfaceManager.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15-8-5.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//  网络层

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"


// 操作成功（网络请求成功，返回值Success = true，两个条件同时成立，才会回调该方法）
typedef void (^RequestSuccessBlock)(AFHTTPRequestOperation *operation, ResponseModel *response);
// 操作失败（网络原因的失败，或者 返回值Success != true，则执行下面的回调）
typedef void (^RequestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error, ResponseErrorModel *responseError);


// 列举所有接口后缀

#pragma mark - 注册、登录

// 注册
static NSString *const API_USER_REGISTER = @"/sales/user/Register";

// 登录
static NSString *const API_USER_LOGIN = @"/sales/user/Login";

// 授权登录
static NSString *const API_USER_AUTHLOGIN = @"/sales/user/authLogin";

// 授权后自动登录
static NSString *const API_USER_AUTOAUTHLOGIN = @"/sales/user/AutoLogin";


#pragma mark - 第三方平台绑定用户账号、解绑

// 绑定
static NSString *const API_USER_THIRDPARTBIND = @"/sales/user/setThirdParty";


#pragma mark - 首页

// 最新五项报销记录
static NSString *const API_USER_GETNEWFIVELIST = @"/sales/user/GetByNewFive";

// 所有报销状态数量
static NSString *const API_USER_GETALLSTATUS = @"/sales/user/GetByStatus";

// 获取当前状态的所有发票
static NSString *const API_USER_GETClaimBYTYPE = @"/sales/user/GetByStatusList";


#pragma mark - 发票

// 按类型查找发票
static NSString *const API_USER_GETREPORTBYTYPE = @"/sales/user/GetByStatusList";

// 按年月查找月报表
static NSString *const API_USER_GETREPORTBYMONTH = @"/sales/content/contentByUser";

// 按年月查找发票记录
static NSString *const API_USER_GETCLAIMBYMONTH = @"/sales/content/contentByUserId";

// 获取发票类型
static NSString *const API_USER_GETAPPTYPELIST = @"/sales/type/getAppTypeList";

// 新增发票
static NSString *const API_USER_ADDCLAIM = @"/sales/content/addContenByPhone";


#pragma mark - 公司

// 获取公司列表
static NSString *const API_USER_GETCOMPANYINFO = @"/sales/user/getCompanyInfoUserid";

// 新增公司
static NSString *const API_USER_ADDCOMPANYINFO = @"/sales/user/addCompanyInfoByUserid";

// 删除公司
static NSString *const API_USER_DELETECOMPANYINFO = @"/sales/user/deleteCompany";

// 加入公司
static NSString *const API_USER_JOINCOMPANY = @"/sales/user/joinCompany";


#pragma mark - 个人中心

// 修改个人资料
static NSString *const API_USER_UPDATEUSERINFO = @"/sales/user/updateUserInfo";

// 上传个人头像
static NSString *const API_USER_UPDATEUSERIMG = @"/sales/user/updateUserImg";


#pragma mark - OCR

// 上传OCR结果
static NSString *const API_USER_UPDATEOCRINFO = @"/sales/user/ocrRcycle";




/*************************************************************************/



@interface WebService : NSObject

// get
+ (void)startGetRequest:(NSString *)action
                   body:(NSDictionary *)body
            returnClass:(Class)returnClass
                success:(RequestSuccessBlock)sblock
                failure:(RequestFailureBlock)fblock;

// post
+ (void)startPostRequest:(NSString *)action
                    body:(NSDictionary *)body
             returnClass:(Class)returnClass
                 success:(RequestSuccessBlock)sblock
                 failure:(RequestFailureBlock)fblock;

// upload file
+ (void)startRequestForUpload:(NSString *)action
                         body:(NSDictionary *)body
                     filePath:(NSString *)path
                  returnClass:(Class)returnClass
                      success:(RequestSuccessBlock)sblock
                      failure:(RequestFailureBlock)fblock;

// download file
+ (void)startRequestForDownload:(NSString *)remotePath
                   withSavePath:(NSString *)localPath
                        success:(RequestSuccessBlock)sblock
                        failure:(RequestFailureBlock)fblock;


@end
