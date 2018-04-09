//
//  NSDate+akucun.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "NSDate+akucun.h"

@implementation NSDate (akucun)

+ (NSString *) relativeDateString:(NSTimeInterval)time
{
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:time];
    
    const int SECOND = 1;
    const int MINUTE = 60 * SECOND;
    //    const int HOUR = 60 * MINUTE;
    //    const int DAY = 24 * HOUR;
    //    const int MONTH = 30 * DAY;
    
    NSDate *now = [NSDate date];
    NSTimeInterval delta = [dateTime timeIntervalSinceDate:now] * -1.0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger units = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [calendar components:units fromDate:dateTime toDate:now options:0];
    
    NSString *relativeString;
    
    if (delta < 0) {
        relativeString = @"";
        
    } else if (delta < 1 * MINUTE) {
        relativeString = (components.second == 1) ? @"1秒钟前" : [NSString stringWithFormat:@"%ld秒钟前",(long)components.second];
        
    } else if (delta < 2 * MINUTE) {
        relativeString = @"1分钟前";
        
    } else if (delta < 55 * MINUTE) {
        relativeString = [NSString stringWithFormat:@"%ld分钟前",(long)components.minute];
        
    } else if (delta < 75 * MINUTE) {
        relativeString = @"1小时前";
        
    } else if ([dateTime isToday]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"aa HH:mm"];
        [formatter setAMSymbol:@"上午"];
        [formatter setPMSymbol:@"下午"];
        relativeString = [formatter stringFromDate:dateTime];
    }
    else {
        relativeString = [dateTime formattedDateWithFormatString:@"MM/dd HH:mm"];
    }
    return relativeString;
}

- (NSString *) weekDateString
{
    NSString *dateString = nil;
    if ([self isToday]) {
        dateString = @"今天";
    }
    else if ([self isYesterday]) {
        dateString = @"昨天";
    }
    else if ([self isThisWeek]) {
        dateString = [self weekdayStringFromDate];
    }
    else {
        dateString = [self formattedDateWithFormatString:@"yyyy年MM月dd日"];
    }
    return dateString;
}

- (NSString *) normalDateString
{
    NSString *dateString = nil;
    NSDateFormatter *stampFormatter = [NSDateFormatter new];
    stampFormatter.timeZone = [NSTimeZone systemTimeZone];
    [stampFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateString = [stampFormatter stringFromDate:self];
    return dateString;
}

- (BOOL) isYesterday
{
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    // 获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 获得 self 的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps. month ) && (selfCmps.day == nowCmps.day-1);
}

- (BOOL) isThisWeek
{
    NSTimeInterval ts = [self timeIntervalSince1970];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval delta = now - ts;
    return (delta < 24 * 7 * 3600);
    /*
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear ;
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
     */
}

// 根据日期求星期几
- (NSString *) weekdayStringFromDate
{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

@end
