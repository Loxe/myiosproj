//
//  ResponseRecycleList.m
//  akucun
//
//  Created by Jarry on 2017/9/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseRecycleList.h"

@implementation ResponseRecycleList

- (NSString *) resultKey
{
    return @"cartproducts";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    CartProduct *product = [CartProduct yy_modelWithDictionary:dictionary];
    return product;
}

@end
