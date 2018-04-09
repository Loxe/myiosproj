//
//  RequestProductBuy.m
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestProductBuy.h"

@implementation RequestProductBuy

- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_PRODUCT_BUY;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.productId forKey:@"productid"];
    [self.dataParams setParamValue:self.skuId forKey:@"skuid"];
    [self.dataParams setParamValue:self.remark forKey:@"remark"];
    
    [self.dataParams setParamValue:self.cartproductid forKey:@"cartproductid"];
}

@end
