//
//  RequestFollowList.m
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestFollowList.h"

@implementation RequestFollowList

- (void) initData
{
    [super initData];
    
    self.pageno = 1;
    self.pagesize = 20;
}

- (SCHttpResponse *) response
{
    return [ResponseFollowList new];
}

- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_FOLLOW_LIST;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
}

@end
