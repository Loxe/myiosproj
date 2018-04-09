//
//  RequestTeamMembers.m
//  akucun
//
//  Created by deepin do on 2018/1/19.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestTeamMembers.h"
#import "ResponseTeamList.h"

@implementation RequestTeamMembers

- (void) initData
{
    [super initData];
    
    self.pageno   = 1;
    self.pagesize = 20;//每页请求多少
}

//- (NSString *)testHost {
//    return kMemberTestServer;
//}

- (HttpResponseBase *) response
{
    return [ResponseTeamList new];
}

- (NSString *) uriPath
{
    return API_URI_TEAM;
}

- (NSString *) actionId
{
    return ACTION_USER_TEAMMEMBER;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    //
    [self.dataParams setParamIntegerValue:2 forKey:@"version"];

    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
    
    [self.dataParams setParamValue:self.vipfalg forKey:@"vipfalg"];
}

@end
