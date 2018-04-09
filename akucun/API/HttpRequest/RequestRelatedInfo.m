//
//  RequestRelatedInfo.m
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestRelatedInfo.h"

@implementation RequestRelatedInfo

- (HttpResponseBase *) response
{
    return [ResponseRelatedAccount new];
}

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return @"shadowaccountinfo";
}

@end
