//
//  RequestAuthUser.m
//  akucun
//
//  Created by deepin do on 2017/12/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestAuthUser.h"
#import "UserManager.h"

@implementation RequestAuthUser

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_AUTH_USER;
}

// JSON Body
- (void) initJsonBody
{
//    [self.jsonBody setParamValue:[UserManager instance].userId forKey:@"userid"];

    [self.jsonBody setParamValue:self.realname forKey:@"realname"];
    [self.jsonBody setParamValue:self.idcard forKey:@"idcard"];
    [self.jsonBody setParamValue:self.bankcard forKey:@"bankcard"];
    [self.jsonBody setParamValue:self.mobile forKey:@"mobile"];
    [self.jsonBody setParamValue:self.code forKey:@"code"];
    [self.jsonBody setParamValue:self.base64Img forKey:@"base64Img"];
    [self.jsonBody setParamValue:self.base64ImgBac forKey:@"base64ImgBac"];
}

// 直接拼接url
//- (void)initParamsDictionary {
//    [super initParamsDictionary];
//    
////    [self.dataParams setParamValue:[UserManager instance].userId forKey:@"userid"];
//    
//    [self.dataParams setParamValue:self.realname forKey:@"realname"];
//    [self.dataParams setParamValue:self.idcard forKey:@"idcard"];
//    [self.dataParams setParamValue:self.bankcard forKey:@"bankcard"];
//    [self.dataParams setParamValue:self.mobile forKey:@"mobile"];
//    [self.dataParams setParamValue:self.code forKey:@"code"];
//    [self.dataParams setParamValue:self.base64Img forKey:@"base64Img"];
//    [self.dataParams setParamValue:self.base64ImgBac forKey:@"base64ImgBac"];
//}

@end



