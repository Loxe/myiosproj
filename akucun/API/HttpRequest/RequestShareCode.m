//
//  RequestShareCode.m
//  akucun
//
//  Created by Jarry Z on 2018/3/19.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestShareCode.h"

@implementation RequestShareCode

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_SHARE_CODE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self setParam:self.refCode forKey:@"refCode"];
}

@end
