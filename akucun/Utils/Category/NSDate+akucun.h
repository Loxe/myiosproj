//
//  NSDate+akucun.h
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (akucun)

+ (NSString *) relativeDateString:(NSTimeInterval)time;

- (NSString *) weekDateString;

- (NSString *) normalDateString;

- (BOOL) isYesterday;

@end
