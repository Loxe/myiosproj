//
//  RequestAfterSaleList.m
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestAfterSaleList.h"

@implementation RequestAfterSaleList

- (void) initData
{
    [super initData];
    
    self.pageno = 1;
    self.pagesize = 20;
}

- (SCHttpResponse *) response
{
    return [ResponseAfterSaleList new];
}

- (NSString *) uriPath
{
    return API_URI_AFTERSALE;
}

- (NSString *) actionId
{
    return ACTION_AFTERSALE_PAGE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
}

@end
