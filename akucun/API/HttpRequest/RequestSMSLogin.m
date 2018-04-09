//
//  RequestSMSLogin.m
//  akucun
//
//  Created by 王敏 on 2017/6/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestSMSLogin.h"

@implementation RequestSMSLogin

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_SMS_LOGIN;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.phonenum forKey:@"phonenum"];
    [self.dataParams setParamValue:self.authcode forKey:@"authcode"];
}

@end
