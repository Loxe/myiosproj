//
//  RequestTeamDetail.m
//  akucun
//
//  Created by deepin do on 2018/1/19.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestTeamDetail.h"
#import "ResponseTeamDetail.h"

@implementation RequestTeamDetail

//- (NSString *)testHost {
//    return kMemberTestServer;
//}

- (HttpResponseBase *) response
{
    return [ResponseTeamDetail new];
}

- (NSString *) uriPath
{
    return API_URI_TEAM;
}

- (NSString *) actionId
{
    return ACTION_USER_TEAMINFO;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
}


@end
