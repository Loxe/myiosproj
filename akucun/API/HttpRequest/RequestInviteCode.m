//
//  RequestInviteCode.m
//  akucun
//
//  Created by Jarry Zhu on 2017/10/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestInviteCode.h"

@implementation RequestInviteCode

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_INVITECODE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
}

@end
