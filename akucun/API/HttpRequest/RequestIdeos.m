//
//  RequestIdeos.m
//  akucun
//
//  Created by Jarry Z on 2018/2/27.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestIdeos.h"

@implementation RequestIdeos

- (NSString *) uriPath
{
    return API_URI_IDEOS;
}

- (NSString *) actionId
{
    return ACTION_IDEOS;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.type forKey:@"type"];
    [self.dataParams setParamValue:@"iOS" forKey:@"osType"];
}

@end
