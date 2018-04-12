//
//  ResponseDeliverProducts.m
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseDeliverProducts.h"

@implementation ResponseDeliverProducts

- (NSString *) resultKey
{
    return @"products";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    CartProduct *product = [CartProduct yy_modelWithDictionary:dictionary];
    return product;
}

@end
