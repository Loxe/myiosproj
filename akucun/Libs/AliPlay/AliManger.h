//
//  AliManger.h
//  akucun
//
//  Created by deepin do on 2017/12/5.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliManger : NSObject

//+ (AliManger*)manager;

- (void)requestSTSWithHandler:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime,  NSError * error))handler;

- (NSInteger)compareNowWithBeforeTime:(NSString *)beforeTime;
- (BOOL)judgeWhetherTokenExpireWithTime:(NSString *)expireTime;


@end
