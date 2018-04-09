//
//  RequestLiveListNew.m
//  akucun
//
//  Created by Jarry Z on 2018/3/15.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestLiveListNew.h"

@implementation RequestLiveListNew

- (HttpResponseBase *) response
{
    ResponseLiveListNew *response = [ResponseLiveListNew new];
    response.modeltype = self.modeltype;
    return response;
}

- (NSString *) uriPath
{
    return API_URI_LIVE;
}

- (NSString *) actionId
{
    return ACTION_LIVE_LISTALL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.modeltype forKey:@"modeltype"];
}

@end
