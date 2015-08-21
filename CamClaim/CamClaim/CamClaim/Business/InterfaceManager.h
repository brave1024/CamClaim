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
 *	@brief	按年月查询发票记录
 *
 *	@param 	month 	年月
 *	@param 	completion  回调block
 */
+ (void)getUserClaimByMonth:(NSString *)month
                 completion:(interfaceManagerBlock)completion;





@end
