//
//  RequestDiscoverList.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestDiscoverList.h"

@implementation RequestDiscoverList

- (void) initData
{
    [super initData];
    
    self.pageno = 1;
    self.pagesize = kPAGE_SIZE;
}

- (HttpResponseBase *) response
{
    return [ResponseDiscoverList new];
}

- (NSString *) uriPath
{
    return API_URI_DISCOVER;
}

- (NSString *) actionId
{
    return ACTION_DISCOVER_LIST;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.type forKey:@"resourceType"];

    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
}

@end
