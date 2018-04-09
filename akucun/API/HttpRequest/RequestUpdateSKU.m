//
//  RequestUpdateSKU.m
//  akucun
//
//  Created by Jarry on 2017/8/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestUpdateSKU.h"

@implementation RequestUpdateSKU

- (SCHttpResponse *) response
{
    ResponseSKUList *response = [ResponseSKUList new];
    response.productIds = self.products;
    return response;
}

- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_SKU_UPDATE;
}

- (void) initJsonBody
{
    NSMutableArray *pIds = [NSMutableArray array];
    for (ProductModel *product in self.products) {
        [pIds addObject:product.Id];
    }
    
    [self.jsonBody setObject:pIds forKey:@"products"];
}

@end
