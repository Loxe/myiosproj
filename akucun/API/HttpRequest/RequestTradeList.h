//
//  RequestTradeList.h
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestBase.h"

#pragma mark - 关于请求方式
/*
#import "HttpRequestBase.h"
httpMethod保持默认SC_HTTP_GET;
用body里面放参数post，请求类继承SCHttpRequestPOST.h，用serviceWithPostRequest方式请求
用url拼接参数的post，请求类继承HttpRequestBase.h，还是用serviceRequest方式请求，只是下面方法中返回post
 - (NSInteger)httpMethod {
 return SC_HTTP_POST;
 }
*/

@interface RequestTradeList : HttpRequestBase

@property (nonatomic, assign) NSInteger pagenum; //当前页

@property (nonatomic, assign) NSInteger pagesize; //总页数


@end
