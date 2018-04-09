//
//  RequestAftersaleInfo.h
//  akucun
//
//  Created by Jarry Z on 2018/4/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseAftersaleInfo.h"

@interface RequestAftersaleInfo : HttpRequestBase

@property (nonatomic, copy) NSString *serviceNo;

@end
