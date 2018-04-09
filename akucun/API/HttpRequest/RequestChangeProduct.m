//
//  RequestChangeProduct.m
//  akucun
//
//  Created by Jarry on 2017/6/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestChangeProduct.h"

@implementation RequestChangeProduct

- (NSString *) uriPath
{
    return API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_CHANGE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.orderId forKey:@"orderid"];
    [self.dataParams setParamValue:self.productId forKey:@"cartproductid"];
    [self.dataParams setParamValue:self.skuId forKey:@"newskuid"];
}

@end
