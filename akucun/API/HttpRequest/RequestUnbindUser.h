//
//  RequestUnbindUser.h
//  akucun
//
//  Created by Jarry Z on 2018/3/24.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestUnbindUser : HttpRequestBase

@property (nonatomic, copy) NSString *subAccount;

@end
