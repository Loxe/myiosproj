//
//  RequestCartRecycleList.m
//  akucun
//
//  Created by Jarry on 2017/9/2.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestCartRecycleList.h"

@implementation RequestCartRecycleList

- (SCHttpResponse *) response
{
    return [ResponseRecycleList new];
}

- (NSString *) uriPath
{
    return API_URI_CART;
}

- (NSString *) actionId
{
    return ACTION_CART_RECYCLE;
}

@end
