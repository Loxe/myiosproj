//
//  ResponseRechargeList.m
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseRechargeList.h"

@implementation ResponseRechargeList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    NSString *desc = [jsonData getStringForKey:@"desc"];
    self.desc = [desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) resultKey
{
    return @"deltas";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    RechargeItem *item = [RechargeItem yy_modelWithDictionary:dictionary];
    return item;
}

@end
