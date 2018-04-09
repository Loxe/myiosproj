//
//  ResponseDeliverList.m
//  akucun
//
//  Created by Jarry on 2017/6/25.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseDeliverList.h"
#import "AdOrderManager.h"

@implementation ResponseDeliverList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    // parse response data ...
    
    NSComparator cmptr = ^(id obj1, id obj2){
        AdOrder *p1 = obj1;
        AdOrder *p2 = obj2;
        if (p1.optimestamp < p2.optimestamp) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (p1.optimestamp > p2.optimestamp) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray *array = [self.result sortedArrayUsingComparator:cmptr];
    self.result = [NSMutableArray arrayWithArray:array];
    
}

- (NSString *) resultKey
{
    return @"adorders";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    AdOrder *order = [AdOrder yy_modelWithDictionary:dictionary];
    AdOrder *adOrder = [[AdOrderManager instance] adOrderById:order.adorderid];
    if (adOrder) {
        order.products = adOrder.products;
    }
    return order;
}

@end
