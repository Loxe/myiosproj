//
//  RequestAddrValidateCode.m
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestAddrValidateCode.h"

@implementation RequestAddrValidateCode

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return @"changeaddrValidatecode";
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.code forKey:@"code"];
    [self.dataParams setParamValue:self.phone forKey:@"phone"];
}

@end
