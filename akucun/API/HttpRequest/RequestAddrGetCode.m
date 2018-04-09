//
//  RequestAddrGetCode.m
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestAddrGetCode.h"

@implementation RequestAddrGetCode

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return @"changeaddrgetcode";
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.phone forKey:@"phone"];
}

@end
