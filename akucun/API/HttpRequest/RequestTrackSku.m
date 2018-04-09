//
//  RequestTrackSku.m
//  akucun
//
//  Created by Jarry Z on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestTrackSku.h"

@implementation RequestTrackSku

- (HttpResponseBase *) response
{
    ResponseTrackSku *response = [ResponseTrackSku new];
    response.liveid = self.liveid;
    return response;
}

- (NSString *) uriPath
{
    return API_URI_LIVE;
}

- (NSString *) actionId
{
    return ACTION_LIVE_TRACK_SKU;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.liveid forKey:@"liveid"];
    [self.dataParams setParamDoubleValue:self.syncsku forKey:@"syncsku"];
}

@end
