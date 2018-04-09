//
//  RequestLiveUpdate.m
//  akucun
//
//  Created by Jarry Z on 2018/3/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestLiveUpdate.h"

@implementation RequestLiveUpdate

- (NSString *) uriPath
{
    return API_URI_LIVE;
}

- (NSString *) actionId
{
    return ACTION_LIVE_UPDATE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.liveid forKey:@"liveid"];
}

@end
