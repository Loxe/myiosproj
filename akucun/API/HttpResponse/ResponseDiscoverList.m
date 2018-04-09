//
//  ResponseDiscoverList.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseDiscoverList.h"

@implementation ResponseDiscoverList

- (NSString *) resultKey
{
    return @"discover";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    DiscoverData *data = [DiscoverData yy_modelWithDictionary:dictionary];
    return data;
}

@end
