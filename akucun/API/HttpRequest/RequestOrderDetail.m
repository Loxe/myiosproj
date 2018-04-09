//
//  RequestOrderDetail.m
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestOrderDetail.h"

@implementation RequestOrderDetail

- (SCHttpResponse *) response
{
    return [ResponseOrderDetail new];
}

- (NSString *) uriPath
{
    return API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_DETAIL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.orderid forKey:@"orderid"];
}

@end
