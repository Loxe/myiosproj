//
//  RequestOrderCancel.m
//  akucun
//
//  Created by Jarry on 2017/4/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestOrderCancel.h"

@implementation RequestOrderCancel

- (NSString *) uriPath
{
    return API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_CANCEL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.orderid forKey:@"orderid"];
}

@end
