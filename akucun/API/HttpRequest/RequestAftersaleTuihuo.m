//
//  RequestAftersaleTuihuo.m
//  akucun
//
//  Created by Jarry on 2017/9/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestAftersaleTuihuo.h"

@implementation RequestAftersaleTuihuo

- (NSString *) uriPath
{
    return API_URI_AFTERSALE;
}

- (NSString *) actionId
{
    return ACTION_AFTERSALE_TUIHUO;
}

- (void) initJsonBody
{
    [self.jsonBody setParamValue:self.refundhao forKey:@"refundhao"];
    [self.jsonBody setParamValue:self.refundcorp forKey:@"refundcorp"];
    
    [self.jsonBody setParamValue:self.cartproductid forKey:@"cartproductid"];
}

@end
