//
//  RequestMemberBuy.m
//  akucun
//
//  Created by Jarry on 2017/8/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestMemberBuy.h"

@implementation RequestMemberBuy

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_VIPBUY;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self setParam:self.productid forKey:@"productid"];
    [self setParam:self.transactionid forKey:@"transactionid"];
    
}

@end
