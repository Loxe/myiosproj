//
//  ResponseRelatedUserList.m
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseRelatedUserList.h"

@implementation ResponseRelatedUserList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    NSDictionary *saleDic = [jsonData objectForKey:@"membersale"];
    if (saleDic) {
        self.totalSales = [saleDic getDoubleValueForKey:@"accountAndShadowSum"];
        self.accountSales = [saleDic getDoubleValueForKey:@"accountSale"];
        self.shadowSales = [saleDic getDoubleValueForKey:@"shadowSales"];
    }
}

- (NSString *) resultKey
{
    return @"memberinfo";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    Member *item = [Member yy_modelWithDictionary:dictionary];
    return item;
}

@end
