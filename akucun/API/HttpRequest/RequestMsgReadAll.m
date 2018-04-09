//
//  RequestMsgReadAll.m
//  akucun
//
//  Created by Jarry on 2017/7/1.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestMsgReadAll.h"

@implementation RequestMsgReadAll

- (NSString *) uriPath
{
    return API_URI_MESSAGE;
}

- (NSString *) actionId
{
    return ACTION_MESSAGE_READALL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
}

@end
