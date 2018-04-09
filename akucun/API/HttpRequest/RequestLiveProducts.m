//
//  RequestLiveProducts.m
//  akucun
//
//  Created by Jarry Z on 2018/1/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestLiveProducts.h"

@implementation RequestLiveProducts

- (HttpResponseBase *) response
{
    return [ResponseLiveProducts new];
}

- (NSString *) uriPath
{
    return API_URI_LIVE;
}

- (NSString *) actionId
{
    return ACTION_LIVE_PRODUCTS;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];

    [self.dataParams setParamValue:self.liveid forKey:@"liveid"];
    [self.dataParams setParamIntegerValue:self.lastxuhao forKey:@"lastxuhao"];
}

@end
