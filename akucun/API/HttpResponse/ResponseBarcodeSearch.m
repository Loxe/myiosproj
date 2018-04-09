//
//  ResponseBarcodeSearch.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseBarcodeSearch.h"

@implementation ResponseBarcodeSearch

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
