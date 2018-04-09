//
//  RequestRelatedUserList.m
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestRelatedUserList.h"

@implementation RequestRelatedUserList

- (HttpResponseBase *) response
{
    return [ResponseRelatedUserList new];
}

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return @"accountShadowList";
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.month forKey:@"month"];
}

@end
