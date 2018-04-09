//
//  RequestDeliverList.m
//  akucun
//
//  Created by Jarry on 2017/6/25.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestDeliverList.h"

@implementation RequestDeliverList

- (void) initData
{
    [super initData];
    
    self.pageno = 1;
    self.pagesize = kPAGE_SIZE;
}

- (SCHttpResponse *) response
{
    return [ResponseDeliverList new];
}

- (NSString *) uriPath
{
    return API_URI_DELIVER;
}

- (NSString *) actionId
{
    return ACTION_DELIVER_LIST;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
    [self.dataParams setParamIntegerValue:self.statu forKey:@"statu"];
}

@end
