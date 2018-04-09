//
//  RequestLiveList.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/28.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestLiveList.h"

@implementation RequestLiveList

- (HttpResponseBase *) response
{
    return [ResponseLiveList new];
}

- (NSString *) uriPath
{
    return API_URI_LIVE;
}

- (NSString *) actionId
{
    return ACTION_LIVE_LIST;
}

@end
