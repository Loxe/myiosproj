//
//  RequestCartSaveStatus.m
//  akucun
//
//  Created by Jarry Z on 2018/3/24.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestCartSaveStatus.h"

@implementation RequestCartSaveStatus

- (NSString *) uriPath
{
    return API_URI_CART;
}

- (NSString *) actionId
{
    return ACTION_CART_STATUS;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamIntegerValue:self.isMerge forKey:@"isMerge"];
}

@end
