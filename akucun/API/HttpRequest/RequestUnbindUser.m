//
//  RequestUnbindUser.m
//  akucun
//
//  Created by Jarry Z on 2018/3/24.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestUnbindUser.h"

@implementation RequestUnbindUser

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return ACTION_USER_UNBIND_SUB;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self setParam:self.subAccount forKey:@"subAccount"];
}

@end
