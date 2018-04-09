//
//  RequestBindPhone.m
//  akucun
//
//  Created by Jarry on 2017/7/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestBindPhone.h"

@implementation RequestBindPhone

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_BIND_PHONE;
}

- (void) initJsonBody
{
    // 设备唯一ID
    NSString *deviceid = [ServerManager instance].deviceId;
    [self.jsonBody setParamValue:deviceid forKey:@"deviceid"];
    
    [self.jsonBody setParamValue:self.phonenum forKey:@"phonenum"];
    [self.jsonBody setParamValue:self.authcode forKey:@"authcode"];

    [self.jsonBody setParamValue:self.subuserid forKey:@"subuserid"];
    [self.jsonBody setParamValue:self.token forKey:@"token"];
}

@end
