//
//  RequestAftersaleInfo.m
//  akucun
//
//  Created by Jarry Z on 2018/4/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestAftersaleInfo.h"

@implementation RequestAftersaleInfo

- (SCHttpResponse *) response
{
    return [ResponseAftersaleInfo new];
}

- (NSString *) uriPath
{
    return API_URI_AFTERSALE;
}

- (NSString *) actionId
{
    return ACTION_AFTERSALE_INFO;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.serviceNo forKey:@"serviceNo"];
}

@end
