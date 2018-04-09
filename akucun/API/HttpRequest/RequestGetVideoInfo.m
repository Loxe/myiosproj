//
//  RequestGetVideoInfo.m
//  akucun
//
//  Created by Jarry Z on 2018/4/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestGetVideoInfo.h"

@implementation RequestGetVideoInfo

- (NSString *) uriPath
{
    return API_URI_DISCOVER;
}

- (NSString *) actionId
{
    return ACTION_DISCOVER_VIDEO;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.videoId forKey:@"videoId"];
}

@end
