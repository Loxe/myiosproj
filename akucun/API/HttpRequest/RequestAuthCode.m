//
//  RequestAuthCode.m
//  akucun
//
//  Created by Jarry Zhu on 2018/1/2.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestAuthCode.h"

@implementation RequestAuthCode

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_AUTH_CODE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.phonenum forKey:@"phonenum"];
    [self.dataParams setParamIntegerValue:self.type forKey:@"type"];
}

@end
