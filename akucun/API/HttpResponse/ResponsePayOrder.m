//
//  ResponsePayOrder.m
//  akucun
//
//  Created by Jarry on 2017/5/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponsePayOrder.h"

@implementation ResponsePayOrder

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    self.payInfo = [jsonData objectForKey:@"payinfo"];
    self.paymentId = [jsonData getStringForKey:@"payment_id"];
    
    OrderModel *order = [OrderModel new];
    order.zongjine = [jsonData getIntegerValueForKey:@"total_amount"];
    order.yunfei = [jsonData getIntegerValueForKey:@"total_yunfeijine"];
    order.shangpinjine = [jsonData getIntegerValueForKey:@"total_shangpinjine"];
    order.dikoujine = [jsonData getIntegerValueForKey:@"total_dikoujine"];
    self.order = order;
}

@end
