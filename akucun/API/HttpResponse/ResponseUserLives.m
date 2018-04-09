//
//  ResponseUserLives.m
//  akucun
//
//  Created by Jarry Z on 2018/1/22.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseUserLives.h"

@implementation ResponseUserLives

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    LiveInfo *liveInfo = [LiveInfo yy_modelWithDictionary:dictionary];
    return liveInfo;
}

@end
