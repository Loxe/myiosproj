//
//  RequestLiveTrailer.m
//  akucun
//
//  Created by Jarry on 2017/3/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestLiveTrailer.h"

@implementation RequestLiveTrailer

- (SCHttpResponse *) response
{
    return [ResponseLiveTrailer new];
}

- (NSString *) uriPath
{
    return API_URI_LIVE;
}

- (NSString *) actionId
{
    return ACTION_LIVE_TRAILER;
}

@end
