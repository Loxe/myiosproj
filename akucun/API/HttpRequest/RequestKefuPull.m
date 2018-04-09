//
//  RequestKefuPull.m
//  akucun
//
//  Created by Jarry on 2017/9/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestKefuPull.h"

@implementation RequestKefuPull

- (SCHttpResponse *) response
{
    return [ResponseKefuMsgList new];
}

- (NSString *) uriPath
{
    return API_URI_KEFU;
}

- (NSString *) actionId
{
    return ACTION_KEFU_PULL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.lastxuhao forKey:@"lastxuhao"];
}

@end
