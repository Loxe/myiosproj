//
//  RequestDelAddr.m
//  akucun
//
//  Created by Jarry on 2017/7/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestDelAddr.h"

@implementation RequestDelAddr

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_DELADDR;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self setParam:self.addrid forKey:@"addrid"];
}

@end
