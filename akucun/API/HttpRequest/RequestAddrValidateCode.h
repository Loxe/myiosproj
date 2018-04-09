//
//  RequestAddrValidateCode.h
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

/**
 修改地址时 校验验证码
 */
@interface RequestAddrValidateCode : HttpRequestBase

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *phone;

@end
