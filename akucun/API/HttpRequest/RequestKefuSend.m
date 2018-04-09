//
//  RequestKefuSend.m
//  akucun
//
//  Created by Jarry on 2017/9/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestKefuSend.h"

@implementation RequestKefuSend

- (NSString *) uriPath
{
    return API_URI_KEFU;
}

- (NSString *) actionId
{
    return ACTION_KEFU_PUSH;
}

- (void) initJsonBody
{
//    NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
//    [msgDic setParamValue:self.content forKey:@"content"];
//    [self.jsonBody setValue:msgDic forKey:@"addr"];

    [self.jsonBody setParamValue:self.content forKey:@"content"];
}

@end
