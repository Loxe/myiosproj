//
//  RequestReportInfo.m
//  akucun
//
//  Created by Jarry on 2017/9/26.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestReportInfo.h"

@implementation RequestReportInfo

- (NSString *) uriPath
{
    return API_URI_SYSTEM;
}

- (NSString *) actionId
{
    return ACTION_SYS_REPORT;
}

- (void) initJsonBody
{
    // did
    NSString *did = [ServerManager instance].deviceId;
    [self.jsonBody setValue:did forKey:@"did"];

    //
#ifdef APPSTORE
    [self.jsonBody setValue:@"1001" forKey:@"sourceno"];
#else
    [self.jsonBody setValue:@"1000" forKey:@"sourceno"];
#endif
}

@end
