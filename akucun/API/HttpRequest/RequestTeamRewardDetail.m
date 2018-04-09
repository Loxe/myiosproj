//
//  RequestTeamRewardDetail.m
//  akucun
//
//  Created by deepin do on 2018/1/20.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestTeamRewardDetail.h"
#import "ResponseTeamRewardDetail.h"

@implementation RequestTeamRewardDetail

//- (NSString *)testHost {
//    return kMemberTestServer;
//}

- (HttpResponseBase *) response
{
    return [ResponseTeamRewardDetail new];
}

- (NSString *) uriPath
{
    return API_URI_TEAM;
}

- (NSString *) actionId
{
    return ACTION_USER_TEAMDETAIL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.month forKey:@"month"];
}

@end
