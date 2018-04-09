//
//  RequestModifyUser.m
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestModifyUser.h"
#import "UserManager.h"
#import "ResponseModifyUser.h"

@implementation RequestModifyUser

- (SCHttpResponse *) response
{
    return [ResponseModifyUser new];
}

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_MODIFY_USER;
}

// JSON Body
- (void) initJsonBody
{
    [self.jsonBody setParamValue:self.nicheng forKey:@"nicheng"];
    [self.jsonBody setParamValue:self.base64Img forKey:@"base64Img"];
}

@end
