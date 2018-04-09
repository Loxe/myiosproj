//
//  RequestUserActive.m
//  akucun
//
//  Created by Jarry Z on 2018/2/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestUserActive.h"

@implementation RequestUserActive

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_ACTIVATE;
}

@end
