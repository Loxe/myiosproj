//
//  AliManger.m
//  akucun
//
//  Created by deepin do on 2017/12/5.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AliManger.h"
#import "RequestDiscoverUpAuth.h"

@implementation AliManger

// not working
//+ (AliManger*)manger {
//    static dispatch_once_t once;
//    
//    static AliManger *manger;
//    dispatch_once(&once, ^{ manger = [[AliManger alloc]init]; });
//
//    return manger;
//}

- (void)requestSTSWithHandler:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime,  NSError * error))handler {
    
    RequestDiscoverUpAuth *request = [RequestDiscoverUpAuth new];
    [SCHttpServiceFace serviceWithRequest:request onSuccess:^(id content) {
        
        SCHttpResponse *response = content;
        NSDictionary *dict = (NSDictionary *)response.responseData;
        NSLog(@"token info -- %@",dict);
        
        NSString *token      = dict[@"secToken"];
        NSString *keyId      = dict[@"akId"];
        NSString *keySecret  = dict[@"akSecret"];
        NSString *expireTime = dict[@"expiration"];
        
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"secToken"];
        [[NSUserDefaults standardUserDefaults] setObject:keyId forKey:@"akId"];
        [[NSUserDefaults standardUserDefaults] setObject:keySecret forKey:@"akSecret"];
        [[NSUserDefaults standardUserDefaults] setObject:expireTime forKey:@"expiration"];
        
        handler(keyId, keySecret, token, expireTime, nil);
        
    } onFailed:^(id content) {
        NSLog(@"requestSTSWithHandler - Failed %@",content);
    }];
}

- (BOOL)judgeWhetherTokenExpireWithTime:(NSString *)expireTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate   *now     = [NSDate date];
    NSString *nowstr  = [formatter stringFromDate:now];
    NSDate   *nowDate = [formatter dateFromString:nowstr];
    
    NSTimeInterval expire  = [expireTime doubleValue] / 1000;
    NSTimeInterval current = [nowDate timeIntervalSince1970]*1;
    
//    NSDate *expireDate = [NSDate dateWithTimeIntervalSince1970:expire];
//    NSTimeInterval seconds = [nowDate timeIntervalSinceDate:expireDate];
//    NSLog(@"相隔seconds---%f",seconds);
    
    /* 确认服务器拿到时间戳是不是对的
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:expire];
    NSString *dateString = [formatter stringFromDate: date];
    POPUPINFO(dateString);
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    */
    
    if (expire-current > 120) { //两分钟的误差偏移
        return NO;
    } else {
        return YES;
    }
}

- (NSInteger)compareNowWithBeforeTime:(NSString *)beforeTime
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *beforeDate =[formatter dateFromString:beforeTime];
    
    NSString *nowstr = [formatter stringFromDate:now];
    NSDate *nowDate = [formatter dateFromString:nowstr];
    
    NSTimeInterval before = [beforeDate timeIntervalSince1970]*1;
    NSTimeInterval end = [nowDate timeIntervalSince1970]*1;
    NSTimeInterval value = end - before;
    NSInteger sec = (NSInteger)value;
    
    return sec;
}

@end
