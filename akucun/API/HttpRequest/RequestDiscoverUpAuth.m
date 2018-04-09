//
//  RequestDiscoverUpAuth.m
//  akucun
//
//  Created by deepin do on 2017/12/1.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestDiscoverUpAuth.h"

@implementation RequestDiscoverUpAuth

- (NSString *) uriPath
{
    return API_URI_DISCOVER;
}

- (NSString *) actionId
{
    return ACTION_DISCOVER_UPAuth;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
//    [self.dataParams setParamValue:self.productId forKey:@"productid"];
//    [self.dataParams setParamValue:self.skuId forKey:@"skuid"];
//    [self.dataParams setParamValue:self.remark forKey:@"remark"];
//
//    [self.dataParams setParamValue:self.cartproductid forKey:@"cartproductid"];
}

@end
