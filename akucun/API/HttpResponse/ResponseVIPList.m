//
//  ResponseVIPList.m
//  akucun
//
//  Created by Jarry on 2017/9/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseVIPList.h"

@implementation ResponseVIPList

- (NSString *) resultKey
{
    return @"purchases";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    VIPItem *vipItem = [VIPItem yy_modelWithDictionary:dictionary];
    return vipItem;
}

@end
