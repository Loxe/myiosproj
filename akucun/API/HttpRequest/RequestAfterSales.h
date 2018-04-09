//
//  RequestAfterSales.h
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseAfterSales.h"

@interface RequestAfterSales : HttpRequestBase

@property (nonatomic, assign) NSInteger pageno;

@property (nonatomic, assign) NSInteger pagesize;

@property (nonatomic, assign) NSInteger status;

@end
