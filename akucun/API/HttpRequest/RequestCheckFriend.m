//
//  RequestCheckFriend.m
//  akucun
//
//  Created by Jarry Z on 2018/4/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestCheckFriend.h"

@implementation RequestCheckFriend

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return @"existfriend";
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.mainDaigouid forKey:@"mainDaigouid"];
    NSString *shadowUserid = [UserManager userId];
    [self.dataParams setParamValue:shadowUserid forKey:@"shadowmemberid"];
}

@end
