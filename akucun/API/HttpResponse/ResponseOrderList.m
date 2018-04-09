//
//  ResponseOrderList.m
//  akucun
//
//  Created by Jarry on 2017/4/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseOrderList.h"

@implementation ResponseOrderList

- (NSString *) resultKey
{
    return @"orders";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    OrderModel *order = [OrderModel yy_modelWithDictionary:dictionary];
    return order;
}

@end
