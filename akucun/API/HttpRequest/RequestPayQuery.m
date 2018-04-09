//
//  RequestPayQuery.m
//  akucun
//
//  Created by Jarry Z on 2018/1/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestPayQuery.h"

@implementation RequestPayQuery

- (NSString *) uriPath
{
    return API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_PAYQUERY;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.paymentId forKey:@"payment_id"];
}

@end
