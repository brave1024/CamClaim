//
//  NSDate+DateHelper.m
//  DonaldOA
//
//  Created by Ian on 14-12-14.
//  Copyright (c) 2014年 Ian. All rights reserved.
//

#import "NSDate+DateHelper.h"


//#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | (NSCalendarUnitWeekOfMonth || NSCalendarUnitWeekOfYear) |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]


@implementation NSDate (DateHelper)

#pragma mark Decomposing Dates

- (NSInteger)nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
//    NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitHour fromDate:newDate];

    return components.hour;
}

- (NSInteger)hour
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}

- (NSInteger)minute
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}

- (NSInteger)seconds
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.second;
}

- (NSInteger)day
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}

- (NSInteger)month
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}

- (NSInteger)week
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.week;
}

- (NSInteger)weekday
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekday;
}

- (NSInteger)nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger)year
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.year;
}


// 获取今天是星期几
- (NSInteger)dayOfWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
//                                                     fromDate:self];
    NSDateComponents *offsetComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                     fromDate:self];
    
    NSInteger y = [offsetComponents year];
    NSInteger m = [offsetComponents month];
    NSInteger d = [offsetComponents day];
    static int t[] = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    y -= m < 3;
    
    
    
    
    
    NSInteger result=(y + y/4 - y/100 + y/400 + t[m-1] + d) % 7;
    if (result == 0)
     {
        result = 7;
    }
    return result;
}

// 获取每月有多少天
- (NSInteger)monthOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
//                                                     fromDate:self];
    NSDateComponents *offsetComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                     fromDate:self];
    
    NSInteger y = [offsetComponents year];
    NSInteger m = [offsetComponents month];
    if (m == 2)
    {
        if (y%4==0 && (y%100!=0 || y%400==0))
        {
            return 29;
        }
        return 28;
    }
    if (m==4 || m==6 || m==9 || m==11)
    {
        return 30;
    }
    
    return 31;
}

// 本周开始时间
- (NSDate *)beginningOfWeek
{
    NSInteger weekday=[self dayOfWeek];
    return  [self addDay:(weekday-1)*-1];
}

// 本周结束时间
- (NSDate *)endOfWeek
{
    NSInteger weekday=[self dayOfWeek];
    if (weekday == 7)
    {
        return self;
    }
    return [self addDay:7-weekday];
}

// 日期添加几天
- (NSDate *)addDay:(NSInteger)day
{
    NSTimeInterval interval = 24 * 60 * 60;
    return  [self dateByAddingTimeInterval:day*interval];
}

// 日期格式化
- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

// 字符串转换成时间
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

// 时间转换成字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format
{
    return [date stringWithFormat:format];
}

// 日期转化成民国时间
- (NSString *)dateToTW:(NSString *)string
{
    NSString *str = [self stringWithFormat:string];
    int y = [[str substringWithRange:NSMakeRange(0, 4)] intValue];
    return [NSString stringWithFormat:@"%d%@",y-1911,[str stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""]];
}


- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone =  [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

@end
