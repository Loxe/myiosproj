//
//  RequestAftersaleApply.m
//  akucun
//
//  Created by Jarry on 2017/9/11.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestAftersaleApply.h"

@implementation RequestAftersaleApply

- (NSString *) uriPath
{
    return API_URI_AFTERSALE;
}

- (NSString *) actionId
{
    return ACTION_AFTERSALE_APPLY;
}

- (void) initJsonBody
{
    [self.jsonBody setParamValue:self.cartproductid forKey:@"cartproductid"];
    [self.jsonBody setParamValue:self.problemdesc forKey:@"problemdesc"];
    [self.jsonBody setParamIntegerValue:self.problemtype forKey:@"problemtype"];
    [self.jsonBody setParamIntegerValue:self.expecttype forKey:@"expecttype"];
    
    //
    if (self.pingzheng) {
        [self.jsonBody setParamValue:self.pingzheng forKey:@"pingzheng"];
    }
    else {
        [self.jsonBody setParamValue:@[] forKey:@"pingzheng"];
    }
}

@end
