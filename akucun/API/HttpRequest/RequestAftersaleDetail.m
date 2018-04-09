//
//  RequestAftersaleDetail.m
//  akucun
//
//  Created by Jarry on 2017/9/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestAftersaleDetail.h"

@implementation RequestAftersaleDetail

- (SCHttpResponse *) response
{
    return [ResponseAftersaleInfo new];
}

- (NSString *) uriPath
{
    return API_URI_AFTERSALE;
}

- (NSString *) actionId
{
    return ACTION_AFTERSALE_DETAIL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.cartproductid forKey:@"cartproductid"];
}

@end
