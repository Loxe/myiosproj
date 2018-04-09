//
//  RequestOrderDetail.h
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseOrderDetail.h"

@interface RequestOrderDetail : HttpRequestBase

@property (nonatomic, copy) NSString *orderid;

@end
