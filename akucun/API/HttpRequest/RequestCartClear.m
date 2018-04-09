//
//  RequestCartClear.m
//  akucun
//
//  Created by Jarry on 2017/5/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestCartClear.h"

@implementation RequestCartClear

- (NSString *) uriPath
{
    return API_URI_CART;
}

- (NSString *) actionId
{
    return ACTION_CART_CLEAR;
}

- (void) initJsonBody
{
    [self.jsonBody setObject:self.cpids forKey:@"cpids"];
}

@end
