//
//  ResponseRefcodeList.m
//  akucun
//
//  Created by Jarry Z on 2018/3/17.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseRefcodeList.h"

@implementation ResponseRefcodeList

- (NSString *) resultKey
{
    return @"referralCode";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    RefCode *item = [RefCode yy_modelWithDictionary:dictionary];
    return item;
}

@end
