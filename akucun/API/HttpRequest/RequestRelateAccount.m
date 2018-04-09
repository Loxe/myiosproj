//
//  RequestRelateAccount.m
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestRelateAccount.h"

@implementation RequestRelateAccount

- (NSString *) uriPath
{
    return @"entry.do";
}

- (NSString *) actionId
{
    return @"accountRelevance";
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.code forKey:@"code"];
    [self.dataParams setParamValue:self.mainDaigouid forKey:@"mainDaigouid"];
    
    NSString *shadowUserid = [UserManager userId];
    [self.dataParams setParamValue:shadowUserid forKey:@"shadowUserid"];
}

@end
