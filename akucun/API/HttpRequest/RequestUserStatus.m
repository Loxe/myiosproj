//
//  RequestUserStatus.m
//  akucun
//
//  Created by Jarry Z on 2018/3/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestUserStatus.h"

@implementation RequestUserStatus

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_LEVELSTATUS;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:2 forKey:@"version"];
}

@end
