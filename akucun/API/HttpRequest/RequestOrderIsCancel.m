//
//  RequestOrderIsCancel.m
//  akucun
//
//  Created by Jarry Z on 2018/3/26.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestOrderIsCancel.h"

@implementation RequestOrderIsCancel

- (NSString *) uriPath
{
    return API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_IS_CANCEL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.orderid forKey:@"orderid"];
}

@end
