//
//  RequestIDExist.m
//  akucun
//
//  Created by deepin do on 2017/12/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestIDExist.h"
#import "UserManager.h"

@implementation RequestIDExist

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_AUTH_ID;
}

// JSON Body
- (void) initJsonBody
{
//    [self.jsonBody setParamValue:[UserManager instance].userId forKey:@"userId"];
    [self.jsonBody setParamValue:self.idcard forKey:@"idcard"];
}

//// 直接拼接url
//- (void)initParamsDictionary {
//    [super initParamsDictionary];
//
//    [self.dataParams setParamValue:self.idcard forKey:@"idcard"];
//}

@end
