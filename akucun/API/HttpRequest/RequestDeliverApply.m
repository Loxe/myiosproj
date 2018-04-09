//
//  RequestDeliverApply.m
//  akucun
//
//  Created by Jarry on 2017/7/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestDeliverApply.h"

@implementation RequestDeliverApply

- (NSString *) uriPath
{
    return API_URI_DELIVER;
}

- (NSString *) actionId
{
    return ACTION_DELIVER_APPLY;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.adorderid forKey:@"adorderid"];
    [self.dataParams setParamValue:self.liveid forKey:@"liveid"];
}

@end
