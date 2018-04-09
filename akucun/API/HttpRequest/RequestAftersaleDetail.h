//
//  RequestAftersaleDetail.h
//  akucun
//
//  Created by Jarry on 2017/9/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseAftersaleInfo.h"

@interface RequestAftersaleDetail : HttpRequestBase

@property (nonatomic, copy) NSString *cartproductid;

@end
