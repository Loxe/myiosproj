//
//  RequestDeliverLives.m
//  akucun
//
//  Created by Jarry Z on 2018/4/11.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestDeliverLives.h"

@implementation RequestDeliverLives

- (void) initData
{
    [super initData];
    
    self.pageno = 1;
    self.pagesize = kPAGE_SIZE;
}

- (HttpResponseBase *) response
{
    return [ResponseDeliverLives new];
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
    
    [self.dataParams setParamIntegerValue:2 forKey:@"version"];

    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
    [self.dataParams setParamIntegerValue:self.type forKey:@"type"];
}

@end
