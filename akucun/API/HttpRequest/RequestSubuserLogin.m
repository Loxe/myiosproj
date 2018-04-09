//
//  RequestSubuserLogin.m
//  akucun
//
//  Created by Jarry Zhu on 2018/1/2.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestSubuserLogin.h"

@implementation RequestSubuserLogin

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_SUB_LOGIN;
}

- (void) initJsonBody
{
    // 设备唯一ID
    NSString *deviceid = [ServerManager instance].deviceId;
    [self.jsonBody setParamValue:deviceid forKey:@"deviceid"];
    
    [self.jsonBody setParamValue:self.userid forKey:@"userid"];
    [self.jsonBody setParamValue:self.subuserid forKey:@"subuserid"];
    [self.jsonBody setParamValue:self.token forKey:@"token"];
}

@end
