//
//  RequestAddrGetCode.h
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

/**
 修改地址 获取短信验证码
 */
@interface RequestAddrGetCode : HttpRequestBase

@property (nonatomic, copy) NSString *phone;

@end
