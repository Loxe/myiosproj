//
//  ResponseOrderCreate.m
//  akucun
//
//  Created by Jarry on 2017/5/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseOrderCreate.h"

@implementation ResponseOrderCreate

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    self.orderids = [jsonData objectForKey:@"orderids"];

    NSInteger count = 0;
    NSInteger i = 0;
    for (OrderModel *item in self.result) {
        count += item.shangpinjianshu;
        item.orderid = self.orderids[i];
        i ++;
    }
    
    OrderModel *order = [OrderModel new];
    order.zongjine = [jsonData getIntegerValueForKey:@"total_amount"];
    order.yunfei = [jsonData getIntegerValueForKey:@"total_yunfeijine"];
    order.shangpinjine = [jsonData getIntegerValueForKey:@"total_shangpinjine"];
    order.dikoujine = [jsonData getIntegerValueForKey:@"total_dikoujine"];
    
    order.shangpinjianshu = count;
    
    self.order = order;
}

- (NSString *) resultKey
{
    return @"orders";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    OrderModel *order = [OrderModel yy_modelWithDictionary:dictionary];
    return order;
}

@end
