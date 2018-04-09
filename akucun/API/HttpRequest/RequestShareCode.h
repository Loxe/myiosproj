//
//  RequestShareCode.h
//  akucun
//
//  Created by Jarry Z on 2018/3/19.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestShareCode : HttpRequestBase

@property (nonatomic, copy)   NSString  *refCode;

@end
