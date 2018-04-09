//
//  RequestGetSKU.m
//  akucun
//
//  Created by Jarry on 2017/8/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestGetSKU.h"

@implementation RequestGetSKU

- (SCHttpResponse *) response
{
    ResponseSKUList *response = [ResponseSKUList new];
    response.productId = self.productId;
    return response;
}

- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_SKU_GET;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.productId forKey:@"productid"];
}

@end
