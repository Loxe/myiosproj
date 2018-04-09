//
//  RequestUseCode.m
//  akucun
//
//  Created by Jarry Zhu on 2017/10/24.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestUseCode.h"

@implementation RequestUseCode

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_USECODE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self setParam:self.referralcode forKey:@"referralcode"];
}

@end
