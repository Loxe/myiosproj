//
//  RequestBuyRecharge.m
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestBuyRecharge.h"

@implementation RequestBuyRecharge

- (SCHttpResponse *) response
{
    return [ResponseBuyRecharge new];
}

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_BUYDELTA;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.deltaid forKey:@"deltaid"];
    [self.dataParams setParamIntegerValue:self.paytype forKey:@"paytype"];
    [self.dataParams setParamIntegerValue:self.payjine forKey:@"payjine"];
}

@end
