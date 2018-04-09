//
//  RequestThirdLogin.m
//  akucun
//
//  Created by Jarry Zhu on 2018/1/2.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestThirdLogin.h"

@implementation RequestThirdLogin

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_THIRD_LOGIN;
}

- (void) initJsonBody
{
    [self.jsonBody setParamIntegerValue:2 forKey:@"logintype"];
    
    [self.jsonBody setParamValue:self.openid forKey:@"openid"];
    [self.jsonBody setParamValue:self.unionid forKey:@"unionid"];
    [self.jsonBody setParamValue:self.name forKey:@"name"];
    [self.jsonBody setParamValue:self.avatar forKey:@"avatar"];
}

@end
