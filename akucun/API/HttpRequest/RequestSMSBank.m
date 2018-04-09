//
//  RequestSMSBank.m
//  akucun
//
//  Created by deepin do on 2017/12/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestSMSBank.h"
#import "UserManager.h"

@implementation RequestSMSBank

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_AUTH_SMSBank;
}

// JSON Body
- (void) initJsonBody
{
//    [self.jsonBody setParamValue:[UserManager instance].userId forKey:@"userid"];

    [self.jsonBody setParamIntegerValue:self.type forKey:@"type"];
    [self.jsonBody setParamValue:self.mobile forKey:@"mobile"];
}

// 直接拼接url
//- (void)initParamsDictionary {
//    [super initParamsDictionary];
//
////    [self.dataParams setParamValue:[UserManager instance].userId forKey:@"userid"];
//
//    [self.dataParams setParamIntegerValue:self.type forKey:@"type"];
//    [self.dataParams setParamValue:self.mobile forKey:@"mobile"];
//}

@end




