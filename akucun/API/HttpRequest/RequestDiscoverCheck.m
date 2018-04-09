//
//  RequestDiscoverCheck.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestDiscoverCheck.h"
#import "UserManager.h"

@implementation RequestDiscoverCheck

- (HttpResponseBase *) response
{
    return [ResponseDiscoverCheck new];
}

- (NSString *) uriPath
{
    return API_URI_DISCOVER;
}

- (NSString *) actionId
{
    return ACTION_DISCOVER_CHECK;
}

- (void) initParamsDictionary
{
    [super initParamsDictionary];
    
    double lasttime = [UserManager instance].discoverTime;
    [self.dataParams setParamDoubleValue:lasttime forKey:@"lasttime"];
    
    double type1 = [[UserManager instance] discoverTimeWith:1];
    double type2 = [[UserManager instance] discoverTimeWith:2];
    double type3 = [[UserManager instance] discoverTimeWith:3];
    double type4 = [[UserManager instance] discoverTimeWith:4];
    double type5 = [[UserManager instance] discoverTimeWith:5];
    [self.dataParams setParamDoubleValue:type1 forKey:@"typeone"];
    [self.dataParams setParamDoubleValue:type2 forKey:@"typetwo"];
    [self.dataParams setParamDoubleValue:type3 forKey:@"typethree"];
    [self.dataParams setParamDoubleValue:type4 forKey:@"typefour"];
    [self.dataParams setParamDoubleValue:type5 forKey:@"typefive"];
}

@end
