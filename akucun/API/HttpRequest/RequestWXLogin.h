//
//  RequestWXLogin.h
//  akucun
//
//  Created by Jarry Zhu on 2017/3/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

/**
 *  微信登录接口
 */
@interface RequestWXLogin : HttpRequestBase

@property (nonatomic, copy)   NSString  *openId;

@property (nonatomic, copy)   NSString  *unionId;

@property (nonatomic, copy)   NSString  *weixinhao;

@property (nonatomic, copy)   NSString  *weixinName;

@property (nonatomic, copy)   NSString  *avatar;

@end
