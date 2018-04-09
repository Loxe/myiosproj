//
//  RequestAccountDetail.m
//  akucun
//
//  Created by Jarry on 2017/6/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestAccountDetail.h"

@implementation RequestAccountDetail

- (void) initData
{
    [super initData];
    
    self.pageno = 1;
    self.pagesize = 20;
}

- (SCHttpResponse *) response
{
    return [ResponseAccountDetail new];
}

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_ACCOUNT_DETAIL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
}

@end
