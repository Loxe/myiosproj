//
//  RequestLiveCheck.m
//  akucun
//
//  Created by Jarry Z on 2018/3/24.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestLiveCheck.h"
#import "UserManager.h"

@implementation RequestLiveCheck

- (HttpResponseBase *) response
{
    return [ResponseLiveCheck new];
}

- (NSString *) uriPath
{
    return API_URI_LIVE;
}

- (NSString *) actionId
{
    return ACTION_LIVE_CHECKUPDATE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    // 3预告 0直播 1专场 2爆款
    double type0 = [[UserManager instance] liveTimeWith:0];
    double type1 = [[UserManager instance] liveTimeWith:1];
    double type2 = [[UserManager instance] liveTimeWith:2];
    double type3 = [[UserManager instance] liveTimeWith:3];
    [self.dataParams setParamDoubleValue:type0 forKey:@"directseeding"];
    [self.dataParams setParamDoubleValue:type1 forKey:@"performance"];
    [self.dataParams setParamDoubleValue:type2 forKey:@"explosion"];
    [self.dataParams setParamDoubleValue:type3 forKey:@"herald"];
}

@end
