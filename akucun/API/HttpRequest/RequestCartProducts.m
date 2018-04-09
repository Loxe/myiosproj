//
//  RequestCartProducts.m
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestCartProducts.h"

@implementation RequestCartProducts

- (SCHttpResponse *) response
{
    return [ResponseCartProducts new];
}

- (NSString *) uriPath
{
    return API_URI_CART;
}

- (NSString *) actionId
{
    return ACTION_CART_LIST;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
}

@end
