//
//  ResponseUserProducts.m
//  akucun
//
//  Created by Jarry Z on 2018/1/23.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseUserProducts.h"

@implementation ResponseUserProducts

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    // parse response data ...
    
    self.checksheeturl = [jsonData getStringForKey:@"checksheeturl"];
}

- (NSString *) resultKey
{
    return @"list";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    CartProduct *product = [CartProduct yy_modelWithDictionary:dictionary];
    return product;
}

@end
