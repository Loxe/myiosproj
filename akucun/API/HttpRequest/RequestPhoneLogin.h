//
//  RequestPhoneLogin.h
//  akucun
//
//  Created by Jarry Zhu on 2018/1/2.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseSubuserList.h"

/**
 v2.0 手机号登录、注册
 */
@interface RequestPhoneLogin : HttpRequestPOST

// 手机号
@property (nonatomic, copy)   NSString  *phonenum;
// 验证码
@property (nonatomic, copy)   NSString  *authcode;

@end
