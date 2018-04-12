//
//  ResponseDeliverLives.m
//  akucun
//
//  Created by Jarry Z on 2018/4/11.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseDeliverLives.h"

@implementation ResponseDeliverLives

- (NSString *) resultKey
{
    return @"activitys";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    LiveInfo *liveInfo = [LiveInfo yy_modelWithDictionary:dictionary];
    return liveInfo;
}

@end
