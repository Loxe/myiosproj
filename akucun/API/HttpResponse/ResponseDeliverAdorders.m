//
//  ResponseDeliverAdorders.m
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseDeliverAdorders.h"

@implementation ResponseDeliverAdorders

- (NSString *) resultKey
{
    return @"adorderids";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    AdOrder *order = [AdOrder yy_modelWithDictionary:dictionary];
    return order;
}

@end
