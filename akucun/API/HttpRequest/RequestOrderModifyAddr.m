//
//  RequestOrderModifyAddr.m
//  akucun
//
//  Created by Jarry on 2017/8/27.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestOrderModifyAddr.h"

@implementation RequestOrderModifyAddr

- (NSString *) uriPath
{
    return API_URI_DELIVER;
}

- (NSString *) actionId
{
    return ACTION_DELIVER_ADDR;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    [self setParam:self.adorderid forKey:@"adorderid"];
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
    
    [self.jsonBody setValue:addrDic forKey:@"addr"];
}

@end
