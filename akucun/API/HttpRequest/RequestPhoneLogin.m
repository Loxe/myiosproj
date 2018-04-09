//
//  RequestPhoneLogin.m
//  akucun
//
//  Created by Jarry Zhu on 2018/1/2.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestPhoneLogin.h"

@implementation RequestPhoneLogin

- (HttpResponseBase *) response
{
    return [ResponseSubuserList new];
}

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_PHONE_LOGIN;
}

- (void) initJsonBody
{
    // 设备唯一ID
    NSString *deviceid = [ServerManager instance].deviceId;
    [self.jsonBody setParamValue:deviceid forKey:@"deviceid"];

    [self.jsonBody setParamValue:self.phonenum forKey:@"phonenum"];
    [self.jsonBody setParamValue:self.authcode forKey:@"authcode"];
}

@end
