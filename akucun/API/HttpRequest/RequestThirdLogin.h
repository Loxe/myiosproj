//
//  RequestThirdLogin.h
//  akucun
//
//  Created by Jarry Zhu on 2018/1/2.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

/**
 v2.0 第三方登录
 */
@interface RequestThirdLogin : HttpRequestPOST

@property (nonatomic, copy)   NSString  *openid;
@property (nonatomic, copy)   NSString  *unionid;
@property (nonatomic, copy)   NSString  *name;
@property (nonatomic, copy)   NSString  *avatar;

//@property (nonatomic, assign) NSInteger logintype;

@end
