//
//  RequestUserAccount.m
//  akucun
//
//  Created by Jarry on 2017/6/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestUserAccount.h"

@implementation RequestUserAccount

- (SCHttpResponse *) response
{
    return [ResponseUserAccount new];
}

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_ACCOUNT;
}

@end
