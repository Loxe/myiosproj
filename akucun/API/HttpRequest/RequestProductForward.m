//
//  RequestProductForward.m
//  akucun
//
//  Created by Jarry on 2017/4/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestProductForward.h"

@implementation RequestProductForward

- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_PRODUCT_FORWARD;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.productId forKey:@"productid"];
    [self.dataParams setParamIntegerValue:self.dest forKey:@"dest"];
}

@end
