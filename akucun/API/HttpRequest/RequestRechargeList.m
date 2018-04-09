//
//  RequestRechargeList.m
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestRechargeList.h"

@implementation RequestRechargeList

- (SCHttpResponse *) response
{
    return [ResponseRechargeList new];
}

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_GETDELTAS;
}

@end
