//
//  RequestCancelProduct.m
//  akucun
//
//  Created by Jarry Z on 2018/1/22.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestCancelProduct.h"

@implementation RequestCancelProduct

- (NSString *) uriPath
{
    return API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_CANCEL_P;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.orderid forKey:@"orderid"];
    [self.dataParams setParamValue:self.cartproductid forKey:@"cartproductid"];
    
    [self.dataParams setParamValue:@(NO) forKey:@"isall"];
}

@end
