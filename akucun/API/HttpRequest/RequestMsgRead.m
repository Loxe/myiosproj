//
//  RequestMsgRead.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestMsgRead.h"

@implementation RequestMsgRead

- (NSString *) uriPath
{
    return API_URI_MESSAGE;
}

- (NSString *) actionId
{
    return ACTION_MESSAGE_READ;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.msgid forKey:@"msgid"];
}

@end
