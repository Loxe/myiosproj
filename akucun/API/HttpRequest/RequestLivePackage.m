//
//  RequestLivePackage.m
//  akucun
//
//  Created by Jarry Z on 2018/1/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestLivePackage.h"

@implementation RequestLivePackage

- (HttpResponseBase *) response
{
    return [ResponseLivePackage new];
}

- (NSString *) uriPath
{
    return API_URI_LIVE;
}

- (NSString *) actionId
{
    return ACTION_LIVE_PACKAGE;
}

@end
