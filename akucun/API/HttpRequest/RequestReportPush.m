//
//  RequestReportPush.m
//  akucun
//
//  Created by Jarry on 2017/9/26.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestReportPush.h"

@implementation RequestReportPush

- (NSString *) uriPath
{
    return API_URI_SYSTEM;
}

- (NSString *) actionId
{
    return ACTION_SYS_REPORTPUSH;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    NSString *did = [ServerManager instance].deviceId;
    [self.dataParams setParamValue:did forKey:@"did"];

    [self setParam:self.pushId forKey:@"tuisongid"];
}

@end
