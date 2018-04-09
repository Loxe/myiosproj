//
//  RequestPayOrder.h
//  akucun
//
//  Created by Jarry on 2017/5/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponsePayOrder.h"

@interface RequestPayOrder : HttpRequestPOST

@property (nonatomic, assign)   NSInteger paytype;

@property (nonatomic, strong)   NSArray  *orders;

@end
