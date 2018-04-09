//
//  RequestVIPPurchase.m
//  akucun
//
//  Created by Jarry on 2017/9/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestVIPPurchase.h"

@implementation RequestVIPPurchase

- (SCHttpResponse *) response
{
    return [ResponseVIPPurchase new];
}

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_VIPPURCHASE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
 
    [self setParam:self.productid forKey:@"productid"];
    [self.dataParams setParamIntegerValue:self.paytype forKey:@"paytype"];
}

@end
