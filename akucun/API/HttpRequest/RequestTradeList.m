//
//  RequestTradeList.m
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestTradeList.h"
#import "ResponseTradeList.h"

@implementation RequestTradeList

- (void) initData
{
    [super initData];
    
    self.pagenum  = 1;
    self.pagesize = 20;//每页请求多少
    
    //或者
//    self.httpMethod = SC_HTTP_POST;//同下面的返回
}

//- (NSInteger)httpMethod {
//    return SC_HTTP_POST;//用url-post
//}

- (SCHttpResponse *) response
{
    return [ResponseTradeList new];
}

- (NSString *) uriPath
{
    return API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_TRADE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.pagenum forKey:@"pagenum"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
}

@end
