//
//  RequestAuthCode.h
//  akucun
//
//  Created by Jarry Zhu on 2018/1/2.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

#define AUTHCODE_TYPE_LOGIN     5
#define AUTHCODE_TYPE_BIND      3

/**
 v2.0 手机号登录/绑定 获取验证码
 */
@interface RequestAuthCode : HttpRequestBase

// 手机号
@property (nonatomic, copy)   NSString  *phonenum;

// 5: 登录    3: 绑定手机号
@property (nonatomic, assign) NSInteger type;

@end
