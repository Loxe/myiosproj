//
//  RequestChangeWXAccount.m
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestChangeWXAccount.h"

@implementation RequestChangeWXAccount

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return @"changeVXAccount";
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.subUserId forKey:@"subuseridVX"];
}

@end
