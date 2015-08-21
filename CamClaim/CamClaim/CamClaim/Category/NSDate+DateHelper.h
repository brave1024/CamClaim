//
//  NSDate+DateHelper.h
//  DonaldOA
//
//  Created by Ian on 14-12-14.
//  Copyright (c) 2014年 Ian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926


@interface NSDate (DateHelper)

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;

//获取今天是星期几
- (NSInteger)dayOfWeek;
//获取每月有多少天
- (NSInteger)monthOfDay;
//本周开始时间
- (NSDate*)beginningOfWeek;
//本周结束时间
- (NSDate *)endOfWeek;
//日期添加几天
- (NSDate*)addDay:(NSInteger)day;
//日期格式化
- (NSString *)stringWithFormat:(NSString *)format;
//字符串转换成时间
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
//时间转换成字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
//日期转化成民国时间
- (NSString*)dateToTW:(NSString *)string;
// 将UTC转化为GMT时间
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
@end
