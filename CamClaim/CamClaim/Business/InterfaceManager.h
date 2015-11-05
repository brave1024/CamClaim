//
//  InterfaceManager.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15-8-5.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//  接口层

#import <Foundation/Foundation.h>
// Request
#import "WebService.h"
// Model
#import "UserInfoModel.h"
#import "AllClaimStatus.h"
#import "UserBaseInfo.h"
#import "ClaimNewModel.h"
#import "CompanyModel.h"
#import "NoticeInviteModel.h"
#import "CompanyActivityModel.h"

// 请求数据的结果回调
typedef void (^interfaceManagerBlock)(BOOL isSucceed, NSString *message, id data);


@interface InterfaceManager : NSObject

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
          completion:(interfaceManagerBlock)completion;

/**
 *	@brief	用户登录
 *
 *	@param 	account 	邮箱(用户手动注册时输入的邮箱地址，作为手动登录时的账号)
 *	@param 	psw 	密码
 *	@param 	completion 	回调block
 */
+ (void)userLogin:(NSString *)account
         password:(NSString *)psw
       completion:(interfaceManagerBlock)completion;

/**
 *	@brief	用户授权登录<获取用户id与加密密码>
 *
 *	@param 	openid 	第三方授权成功后获取到的用户id
 *	@param 	pic 	用户头像
 *	@param 	completion 	回调block
 */
+ (void)userAuthLogin:(NSString *)openid
                  pic:(NSString *)pic
           completion:(interfaceManagerBlock)completion;

/**
 *	@brief	用户在第三方平台授权成功后，将相应的userid传给后台，后台自动生成一个账号密码(后台自动注册)；app在下次启动时使用后台返回的账号与加密密码进行自动登录操作。
 *
 *	@param 	account 	后台随机生成的用户账号(非邮箱)
 *	@param 	psw 	后台随机生成的加密密码
 *	@param 	completion 	回调block
 */
+ (void)userAutoAuthLogin:(NSString *)account
                 password:(NSString *)psw
               completion:(interfaceManagerBlock)completion;

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
             completion:(interfaceManagerBlock)completion;

/**
 *	@brief	获取当前用户最近五项报销记录
 *
 *	@param 	completion 	回调block
 */
+ (void)getUserNewFiveClaimList:(interfaceManagerBlock)completion;

/**
 *	@brief	获取用户所有报销状态数量
 *
 *	@param 	completion 	回调block
 */
+ (void)getUserAllClaimStatus:(interfaceManagerBlock)completion;

/**
 *	@brief	按年月查询报表记录
 *
 *	@param 	month 	年月
 *	@param 	completion  回调block
 */
+ (void)getUserReportByMonth:(NSString *)month
                  completion:(interfaceManagerBlock)completion;

/**
 *	@brief	按关键字查询发票记录
 *
 *	@param 	key 	关键字
 *	@param 	completion 	回调block
 */
+ (void)getUserReportByKey:(NSString *)key
                completion:(interfaceManagerBlock)completion;

/**
 *	@brief	按年月查询发票记录
 *
 *	@param 	month 	年月
 *	@param 	completion  回调block
 */
+ (void)getUserClaimByMonth:(NSString *)month
                 completion:(interfaceManagerBlock)completion;

/**
 *	@brief	更新个人资料
 *
 *	@param 	baseInfo 	个人资料实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserBaseInfo:(UserBaseInfo *)baseInfo
                completion:(interfaceManagerBlock)completion;

/**
 *	@brief	修改用户密码
 *
 *	@param 	baseInfo 	新密码
 *	@param 	completion 	回调block
 */
+ (void)changeUserPassword:(NSString *)psw
                completion:(interfaceManagerBlock)completion;

/**
 *	@brief	获取发票类型
 *
 *	@param 	completion 	回调block
 */
+ (void)getClaimType:(interfaceManagerBlock)completion;

/**
 *	@brief	获取用户公司
 *
 *	@param 	completion 	回调block
 */
+ (void)getUserCompany:(interfaceManagerBlock)completion;

/**
 *	@brief	增加公司
 *
 *	@param 	company 	公司名
 *	@param 	completion 	回调block
 */
+ (void)addUserCompany:(NSString *)company
                  completion:(interfaceManagerBlock)completion;

/**
 *	@brief	删除公司
 *
 *	@param 	companyid 	公司id
 *	@param 	completion 	回调block
 */
+ (void)deleteUserCompany:(NSString *)companyid
            completion:(interfaceManagerBlock)completion;

/**
 *	@brief	搜索公司
 *
 *	@param 	key 	搜索公司关键字
 *	@param 	completion 	回调block
 */
+ (void)searchCompany:(NSString *)key
           completion:(interfaceManagerBlock)completion;

/**
 *	@brief	增加发票
 *
 *	@param 	claim 	发票实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserNewClaim:(ClaimNewModel *)claim
                completion:(interfaceManagerBlock)completion;

/**
 *	@brief	增加交通类发票
 *
 *	@param 	claim 	发票实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserNewClaimForTraffic:(ClaimNewModel *)claim
                          completion:(interfaceManagerBlock)completion;

/**
 *	@brief	增加住宿类发票
 *
 *	@param 	claim 	发票实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserNewClaimForHotel:(ClaimNewModel *)claim
                        completion:(interfaceManagerBlock)completion;

/**
 *	@brief	增加膳食类发票
 *
 *	@param 	claim 	发票实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserNewClaimForFood:(ClaimNewModel *)claim
                        completion:(interfaceManagerBlock)completion;

/**
 *	@brief	增加其它类发票
 *
 *	@param 	claim 	发票实体
 *	@param 	completion 	回调block
 */
+ (void)submitUserNewClaimForOthers:(ClaimNewModel *)claim
                         completion:(interfaceManagerBlock)completion;

/**
 *	@brief	根据类型查找发票
 *
 *	@param 	type 	发票类型
 *	@param 	completion 	回调block
 */
+ (void)getUserClaimByType:(NSString *)type
                 completion:(interfaceManagerBlock)completion;

/**
 *	@brief	上传用户头像
 *
 *	@param 	type 	image头像的base64编码字符串
 *	@param 	completion 	回调block
 */
+ (void)updateUserImage:(NSString *)img
             completion:(interfaceManagerBlock)completion;


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
             completion:(interfaceManagerBlock)completion;

/**
 *	@brief	加入公司
 *
 *	@param 	companyid 	公司id
 *	@param 	completion 	回调block
 */
+ (void)userJoinCompany:(NSString *)companyid
             completion:(interfaceManagerBlock)completion;


/**
 *	@brief	上传图片ocr信息
 *
 *	@param 	imgData 	图片base64字符串
 *	@param 	imgText 	图片ocr结果
 *	@param 	completion 	回调block
 */
+ (void)userUploadOCRImage:(NSString *)imgData
             withImageData:(NSString *)imgText
                completion:(interfaceManagerBlock)completion;

/**
 *	@brief	获取个人邀请记录
 *
 *	@param 	completion 	回调block
 */
+ (void)getUserInviteRecord:(interfaceManagerBlock)completion;

/**
 *	@brief	获取个人邀请公司相关活动信息
 *
 *	@param 	completion 	回调block
 */
+ (void)getUserInviteCompanyInfo:(interfaceManagerBlock)completion;

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
               completion:(interfaceManagerBlock)completion;


@end
