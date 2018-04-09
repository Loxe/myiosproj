//
//  RequestRelatedGetCode.m
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestRelatedGetCode.h"

@implementation RequestRelatedGetCode

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return @"accountRelevancegetcode";
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.userno forKey:@"userno"];
}

@end
