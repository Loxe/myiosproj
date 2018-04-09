//
//  RequestPaytypes.m
//  akucun
//
//  Created by Jarry on 2017/6/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestPaytypes.h"

@implementation RequestPaytypes

- (SCHttpResponse *) response
{
    return [ResponsePaytypes new];
}

- (NSString *) uriPath
{
    return API_URI_SYSTEM;
}

- (NSString *) actionId
{
    return ACTION_SYS_PAYTYPE;
}


@end
