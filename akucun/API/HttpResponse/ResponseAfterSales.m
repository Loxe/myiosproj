//
//  ResponseAfterSales.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseAfterSales.h"

@implementation ResponseAfterSales

- (NSString *) resultKey
{
    return @"products";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    CartProduct *product = [CartProduct yy_modelWithDictionary:dictionary];
    product.shuliang = 1;
    return product;
}

@end
