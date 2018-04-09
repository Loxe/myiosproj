//
//  RequestChangeWXAccount.h
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestChangeWXAccount : HttpRequestBase

@property (nonatomic, copy) NSString *subUserId;

@end
