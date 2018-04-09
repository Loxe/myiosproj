//
//  ResponseWuliuTrace.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseWuliuTrace.h"

@implementation ResponseWuliuTrace

- (NSString *) resultKey
{
    return @"data";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    LogisticsInfo *item = [LogisticsInfo yy_modelWithDictionary:dictionary];
    return item;
}

@end
