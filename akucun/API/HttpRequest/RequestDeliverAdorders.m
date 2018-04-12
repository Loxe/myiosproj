//
//  RequestDeliverAdorders.m
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestDeliverAdorders.h"

@implementation RequestDeliverAdorders

- (HttpResponseBase *) response
{
    return [ResponseDeliverAdorders new];
}

- (NSString *) uriPath
{
    return API_URI_DELIVER;
}

- (NSString *) actionId
{
    return ACTION_DELIVER_ADORDERS;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:2 forKey:@"version"];

    [self.dataParams setParamValue:self.liveid forKey:@"liveid"];
    [self.dataParams setParamIntegerValue:self.type forKey:@"type"];
}

@end
