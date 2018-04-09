//
//  RequestDeliverList.h
//  akucun
//
//  Created by Jarry on 2017/6/25.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseDeliverList.h"

@interface RequestDeliverList : HttpRequestBase

@property (nonatomic, assign) NSInteger pageno;

@property (nonatomic, assign) NSInteger pagesize;

@property (nonatomic, assign) NSInteger statu;

@end
