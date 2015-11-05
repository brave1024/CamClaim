//
//  NSString+Utils.h
//  KufaLottery
//
//  Created by Xia Zhiyong on 14-9-18.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

// 获取经过RSA加密后的字串
//+ (NSString *)getSignStringByRAS:(NSString *)privateKey withContent:(NSString *)infoString;

// 检验内容是否为空
+ (BOOL)checkContent:(NSString *)message;

// 检查是否有输入非法字符
- (BOOL)checkContentValid;

// 版本号对比
- (BOOL)isNewThanVersion:(NSString *)oldVersion;

// 检测手机号
+ (BOOL)checkTel:(NSString *)mobile;

// 检测身份证
+ (BOOL)checkIDCardNumber:(NSString *)idCard;

// 校验身份证号码 是否合法
+ (BOOL)verifyIDCardNumber:(NSString *)value;

// 校验邮箱
+ (BOOL)checkMailAddress:(NSString *)mailAddress;

// 去掉内容中的超链接
+ (NSString *)removeHyperLinkFromContent:(NSString *)content;

// 去掉内容中的字体标签
+ (NSString *)removeFontTagFromContent:(NSString *)content;

// 判断是否包含指定字符串
- (BOOL)myContainsString:(NSString *)other;

// 检查用户名
- (BOOL)checkUserName;

// 计算字符串高度
- (float)heightWithFont:(UIFont *)font andWidth:(float)width;
- (float)calculateHeightWithFont:(UIFont *)font andWidth:(float)width;  // 已无地方调用

// 计算多行文本高度
- (CGFloat)calculateMultilineHeightWithFont:(UIFont *)font andWidth:(float)width;

// 赔率大于100时,不显示小数位
+ (NSString *)showOddsMethod:(CGFloat)odds;

// 把JSON格式的字符串转换成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

// 获取doc下的图片文件夹
+ (NSString *)getImageLocationPath;

// 生成唯一id
+ (NSString *)generateUniqueId;

// 生成时间格式字串
+ (NSString *)stringWithDate:(NSDate *)date formater:(NSString *)formater;

@end
