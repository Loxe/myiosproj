//
//  RequestPayOrder.m
//  akucun
//
//  Created by Jarry on 2017/5/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestPayOrder.h"

@implementation RequestPayOrder

- (SCHttpResponse *) response
{
    return [ResponsePayOrder new];
}

- (NSString *) uriPath
{
    return API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_PAY;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.paytype forKey:@"paytype"];
}

- (void) initJsonBody
{
    [self.jsonBody setObject:self.orders forKey:@"orderids"];
}

@end
