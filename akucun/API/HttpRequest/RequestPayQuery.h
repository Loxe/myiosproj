//
//  RequestPayQuery.h
//  akucun
//
//  Created by Jarry Z on 2018/1/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestPayQuery : HttpRequestBase

@property (nonatomic, copy) NSString *paymentId;

@end
