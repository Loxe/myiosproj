//
//  RequestAftersaleCancel.m
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "RequestAftersaleCancel.h"

@implementation RequestAftersaleCancel

- (NSString *) uriPath
{
    return API_URI_AFTERSALE;
}

- (NSString *) actionId
{
    return ACTION_AFTERSALE_CANCEL;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.serviceNo forKey:@"serviceNo"];
}

@end
