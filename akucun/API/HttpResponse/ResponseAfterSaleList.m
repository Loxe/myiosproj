//
//  ResponseAfterSaleList.m
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseAfterSaleList.h"

@implementation ResponseAfterSaleList

- (NSString *) resultKey
{
    return @"products";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    ASaleService *service = [ASaleService yy_modelWithDictionary:dictionary];
    return service;
}

@end
