//
//  RequestDeliverDetail.m
//  akucun
//
//  Created by Jarry on 2017/6/25.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestDeliverDetail.h"

@implementation RequestDeliverDetail

- (SCHttpResponse *) response
{
    return [ResponseDeliverDetail new];
}

- (NSString *) uriPath
{
    return API_URI_DELIVER;
}

- (NSString *) actionId
{
    return ACTION_DELIVER_DETAIL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.adorderid forKey:@"adorderid"];
}

@end
