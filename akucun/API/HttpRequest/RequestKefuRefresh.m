//
//  RequestKefuRefresh.m
//  akucun
//
//  Created by Jarry on 2017/9/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestKefuRefresh.h"

@implementation RequestKefuRefresh

- (SCHttpResponse *) response
{
    return [ResponseKefuMsgList new];
}

- (NSString *) uriPath
{
    return API_URI_KEFU;
}

- (NSString *) actionId
{
    return ACTION_KEFU_REFRESH;
}

@end
