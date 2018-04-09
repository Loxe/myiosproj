//
//  RequestSubuserLogin.h
//  akucun
//
//  Created by Jarry Zhu on 2018/1/2.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestSubuserLogin : HttpRequestPOST

@property (nonatomic, copy)   NSString  *userid;
@property (nonatomic, copy)   NSString  *subuserid;
@property (nonatomic, copy)   NSString  *token;

@end
