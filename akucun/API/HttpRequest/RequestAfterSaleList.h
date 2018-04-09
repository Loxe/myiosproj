//
//  RequestAfterSaleList.h
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseAfterSaleList.h"

@interface RequestAfterSaleList : HttpRequestBase

@property (nonatomic, assign) NSInteger pageno;

@property (nonatomic, assign) NSInteger pagesize;

@end
