//
//  RequestModifyAddr.m
//  akucun
//
//  Created by Jarry on 2017/7/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestModifyAddr.h"

@implementation RequestModifyAddr2

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_MODIFYADDR;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    [self setParam:self.addrid forKey:@"addrid"];
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
    
    // 0 默认
    [addrDic setParamIntegerValue:0 forKey:@"defaultflag"];
    
    [self.jsonBody setValue:addrDic forKey:@"addr"];
}

@end
