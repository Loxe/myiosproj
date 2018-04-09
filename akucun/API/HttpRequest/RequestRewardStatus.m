//
//  RequestRewardStatus.m
//  akucun
//
//  Created by Jarry Z on 2018/4/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestRewardStatus.h"

@implementation RequestRewardStatus

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return @"findDrawStatu";
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:2 forKey:@"version"];
}

@end
