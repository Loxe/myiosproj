//
//  RequestUserUpdate.m
//  akucun
//
//  Created by Jarry on 2017/4/16.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestUserUpdate.h"

@implementation RequestUserUpdate

- (NSString *) uriPath
{
    return API_URI_USER;
}

- (NSString *) actionId
{
    return ACTION_USER_UPDATE;
}

- (void) initJsonBody
{
    [self.jsonBody setObject:self.name forKey:@"name"];
//    [self.jsonBody setObject:self.mobile forKey:@"shoujihao"];
    [self.jsonBody setObject:self.weixinhao forKey:@"weixinhao"];
}

@end
