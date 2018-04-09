//
//  RequestSMSCode.h
//  akucun
//
//  Created by 王敏 on 2017/6/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

/**
 *  获取验证码接口
 */
@interface RequestSMSCode : HttpRequestBase

@property (nonatomic, copy)   NSString  *phonenum;
@property (nonatomic, assign) NSInteger type;

@end

