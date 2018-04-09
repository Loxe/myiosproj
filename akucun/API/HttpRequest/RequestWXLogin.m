//
//  RequestWXLogin.m
//  akucun
//
//  Created by Jarry Zhu on 2017/3/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestWXLogin.h"

@implementation RequestWXLogin

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_WX_LOGIN;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.openId forKey:@"openid"];
    [self.dataParams setParamValue:self.unionId forKey:@"unionid"];
    [self.dataParams setParamValue:self.weixinName forKey:@"weixinName"];
    [self.dataParams setParamValue:self.avatar forKey:@"avatar"];
//    [self.dataParams setParamValue:self.weixinhao forKey:@"weixinhao"];
}

@end
