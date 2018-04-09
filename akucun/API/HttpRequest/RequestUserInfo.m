//
//  RequestUserInfo.m
//  akucun
//
//  Created by Jarry Zhu on 2017/3/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestUserInfo.h"
#import "UserManager.h"

@implementation RequestUserInfo

- (SCHttpResponse *) response
{
    return [ResponseUserInfo new];
}

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_GETINFO;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
}

@end
