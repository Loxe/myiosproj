//
//  RequestWuliuTrace.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestWuliuTrace.h"

@implementation RequestWuliuTrace

- (HttpResponseBase *) response
{
    return [ResponseWuliuTrace new];
}

- (NSString *) uriPath
{
    return API_URI_DELIVER;
}

- (NSString *) actionId
{
    return ACTION_DELIVER_TRACE;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.deliverId forKey:@"deliverId"];
    
    if (self.logistics == 0) {
        if ([self.deliverId hasPrefix:@"VB"]) {
            self.logistics = 6;
        }
        else if ([self.deliverId hasPrefix:@"8"]) {
            self.logistics = 18;
        }
    }
    [self.dataParams setParamIntegerValue:self.logistics forKey:@"logistics"];
}

@end
