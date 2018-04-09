//
//  RequestSMSCode.m
//  akucun
//
//  Created by 王敏 on 2017/6/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestSMSCode.h"

@implementation RequestSMSCode

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_SMS_CODE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.phonenum forKey:@"phonenum"];
    [self.dataParams setParamIntegerValue:self.type forKey:@"type"];
}

@end
