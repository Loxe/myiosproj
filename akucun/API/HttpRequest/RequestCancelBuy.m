//
//  RequestCancelBuy.m
//  akucun
//
//  Created by Jarry on 2017/4/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestCancelBuy.h"

@implementation RequestCancelBuy

- (NSString *) uriPath
{
    return API_URI_PRODUCT;
}

- (NSString *) actionId
{
    return ACTION_CANCEL_BUY;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.productId forKey:@"cartproductid"];
}

@end
