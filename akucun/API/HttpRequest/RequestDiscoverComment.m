//
//  RequestDiscoverComment.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestDiscoverComment.h"

@implementation RequestDiscoverComment

- (NSString *) uriPath
{
    return API_URI_DISCOVER;
}

- (NSString *) actionId
{
    return ACTION_DISCOVER_COMMENT;
}
/*
- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    [self.dataParams setParamValue:self.comment forKey:@"comment"];
    [self.dataParams setParamValue:self.contentid forKey:@"contentid"];
}
*/
- (void) initJsonBody
{
    //
    [self.jsonBody setValue:self.comment forKey:@"comment"];
    [self.jsonBody setValue:self.contentid forKey:@"contentid"];
    [self.jsonBody setValue:self.userid forKey:@"userid"];
}

@end
