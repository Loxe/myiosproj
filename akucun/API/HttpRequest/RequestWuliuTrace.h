//
//  RequestWuliuTrace.h
//  akucun
//
//  Created by Jarry Zhu on 2017/12/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseWuliuTrace.h"

@interface RequestWuliuTrace : HttpRequestBase

// 快递单号
@property (nonatomic, copy) NSString *deliverId;

// 快递公司类型：18-德邦，6-京东
@property (nonatomic, assign) NSInteger logistics;

@end
