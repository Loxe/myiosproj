//
//  RequestActiveCode.m
//  akucun
//
//  Created by Jarry Zhu on 2017/10/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestActiveCode.h"

@implementation RequestActiveCode

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_ACTIVECODE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self setParam:self.referralcode forKey:@"referralcode"];
    [self setParam:self.ruserid forKey:@"ruserid"];
}

@end
