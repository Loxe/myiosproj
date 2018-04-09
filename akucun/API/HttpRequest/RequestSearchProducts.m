//
//  RequestSearchProducts.m
//  akucun
//
//  Created by Jarry Z on 2018/2/1.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestSearchProducts.h"

@implementation RequestSearchProducts

- (HttpResponseBase *) response
{
    return [ResponseUserProducts new];
}

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_SEARCH_PROD;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.liveid forKey:@"liveid"];
    [self.dataParams setParamValue:self.info forKey:@"info"];

//    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
//    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
}

@end
