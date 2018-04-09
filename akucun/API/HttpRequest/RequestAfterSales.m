//
//  RequestAfterSales.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestAfterSales.h"

@implementation RequestAfterSales

- (void) initData
{
    [super initData];
    
    self.pageno = 1;
    self.pagesize = kPAGE_SIZE;
}

- (SCHttpResponse *) response
{
    return [ResponseAfterSales new];
}

- (NSString *) uriPath
{
    return API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_AFTERSALE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
    
    [self.dataParams setParamIntegerValue:self.status forKey:@"status"];
}

@end
