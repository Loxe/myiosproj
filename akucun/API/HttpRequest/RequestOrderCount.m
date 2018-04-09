//
//  RequestOrderCount.m
//  akucun
//
//  Created by Jarry on 2017/6/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestOrderCount.h"

@implementation RequestOrderCount

- (NSString *) uriPath
{
    return API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_COUNT;
}

@end
