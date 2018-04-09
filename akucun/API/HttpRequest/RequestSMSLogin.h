//
//  RequestSMSLogin.h
//  akucun
//
//  Created by 王敏 on 2017/6/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#ifndef RequestSMSLogin_h
#define RequestSMSLogin_h


#import "HttpRequestBase.h"

/**
 *  手机号码验证码登录接口
 */
@interface RequestSMSLogin : HttpRequestBase

@property (nonatomic, copy)   NSString  *phonenum;

@property (nonatomic, copy)   NSString  *authcode;

@end



#endif /* RequestSMSLogin_h */
