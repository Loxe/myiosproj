//
//  RequestBindPhone.h
//  akucun
//
//  Created by Jarry on 2017/7/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

/**
 v2.0 绑定手机号
 */
@interface RequestBindPhone : HttpRequestPOST

@property (nonatomic, copy)   NSString  *phonenum;

@property (nonatomic, copy)   NSString  *authcode;

@property (nonatomic, copy)   NSString  *subuserid;

@property (nonatomic, copy)   NSString  *token;

@end
