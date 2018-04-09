//
//  RequestMsgList.m
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestMsgList.h"

@implementation RequestMsgList

- (void) initData
{
    [super initData];
    
    self.pageno = 1;
    self.pagesize = kPAGE_SIZE;
}

- (SCHttpResponse *) response
{
    return [ResponseMsgList new];
}

- (NSString *) uriPath
{
    return API_URI_MESSAGE;
}

- (NSString *) actionId
{
    return ACTION_MESSAGE_LIST;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.pageno forKey:@"pageno"];
    [self.dataParams setParamIntegerValue:self.pagesize forKey:@"pagesize"];
}

@end
