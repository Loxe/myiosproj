//
//  RequestAddAddr.m
//  akucun
//
//  Created by Jarry on 2017/4/4.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestAddAddr.h"

@implementation RequestAddAddr2

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_ADDADDR;
}

- (void) initJsonBody
{
    NSMutableDictionary *addrDic = [NSMutableDictionary dictionary];
    [addrDic setParamValue:self.name forKey:@"shoujianren"];
    [addrDic setParamValue:self.mobile forKey:@"dianhua"];
    [addrDic setParamValue:self.province forKey:@"sheng"];
    [addrDic setParamValue:self.city forKey:@"shi"];
    [addrDic setParamValue:self.area forKey:@"qu"];
    [addrDic setParamValue:self.address forKey:@"detailaddr"];
    [addrDic setParamIntegerValue:0 forKey:@"defaultflag"];
    
    [self.jsonBody setValue:addrDic forKey:@"addr"];
}

@end
