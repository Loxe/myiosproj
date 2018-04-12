//
//  RequestDeliverProducts.m
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestDeliverProducts.h"

@implementation RequestDeliverProducts

- (void) initData
{
    [super initData];
    
    self.pageno = 1;
    self.pagesize = kPAGE_SIZE;
}

- (HttpResponseBase *) response
{
    return [ResponseDeliverProducts new];
}

- (NSString *) uriPath
{
    return API_URI_DELIVER;
}

- (NSString *) actionId
{
    return ACTION_DELIVER_PRODUCTS;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:2 forKey:@"version"];
    
    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
    
    [self.dataParams setParamValue:self.liveid forKey:@"liveid"];
    [self.dataParams setParamValue:self.adorderid forKey:@"adorderid"];
    [self.dataParams setParamIntegerValue:self.type forKey:@"type"];
}
@end
