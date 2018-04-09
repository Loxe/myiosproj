//
//  ProductSKU.m
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ProductSKU.h"

@implementation ProductSKU

+ (NSDictionary *) modelCustomPropertyMapper
{
    return @{ @"Id": @"id"
            };
}

- (NSString *) chima
{
    _chima = [_chima stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    return [_chima stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
