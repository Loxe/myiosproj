//
//  RequestVIPList.m
//  akucun
//
//  Created by Jarry on 2017/9/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestVIPList.h"

@implementation RequestVIPList

- (SCHttpResponse *) response
{
    return [ResponseVIPList new];
}

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_VIPLIST;
}

@end
