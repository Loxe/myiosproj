//
//  RequestRewardReceived.m
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestRewardReceived.h"

@implementation RequestRewardReceived

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return @"confirmdraw";
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:2 forKey:@"version"];

    [self.dataParams setParamIntegerValue:self.type forKey:@"type"];
    [self.dataParams setParamValue:self.reissueid forKey:@"reissueid"];
}

@end
