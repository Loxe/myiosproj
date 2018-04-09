//
//  RequestUserProducts.m
//  akucun
//
//  Created by Jarry Z on 2018/1/23.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestUserProducts.h"

@implementation RequestUserProducts

- (void) initData
{
    [super initData];
    
    self.pageno = 1;
    self.pagesize = kPAGE_SIZE;
}

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
    return ACTION_USER_LIVEPRODUCT;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.liveid forKey:@"liveid"];
     
    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
}

@end
