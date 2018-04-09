//
//  RequestOrderCreate.m
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestOrderCreate.h"

@implementation RequestOrderCreate

- (SCHttpResponse *) response
{
    return [ResponseOrderCreate new];
}

- (NSString *) uriPath
{
    return @"cento.do";// API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_CREATE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    [self.dataParams setParamValue:self.addrid forKey:@"addrid"];
}

- (void) initJsonBody
{
//    [self.jsonBody setObject:self.addrid forKey:@"addrid"];
    [self.jsonBody setObject:self.products forKey:@"cartproductids"];
}

@end
