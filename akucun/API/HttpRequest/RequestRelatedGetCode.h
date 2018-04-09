//
//  RequestRelatedGetCode.h
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

/**
 请求关联账号 获取验证码
 */
@interface RequestRelatedGetCode : HttpRequestBase

@property (nonatomic, copy) NSString *userno;
@property (nonatomic, copy) NSString *userid;

@end
