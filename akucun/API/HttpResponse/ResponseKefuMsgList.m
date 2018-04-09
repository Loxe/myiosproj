//
//  ResponseKefuMsgList.m
//  akucun
//
//  Created by Jarry on 2017/9/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseKefuMsgList.h"

@implementation ResponseKefuMsgList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    NSComparator cmptr = ^(id obj1, id obj2){
        ChatMsg *p1 = obj1;
        ChatMsg *p2 = obj2;
        if (p1.xuhao > p2.xuhao) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (p1.xuhao < p2.xuhao) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray *array = [self.result sortedArrayUsingComparator:cmptr];
    self.result = [NSMutableArray arrayWithArray:array];
}

- (NSString *) resultKey
{
    return @"msgs";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    ChatMsg *msg = [ChatMsg yy_modelWithDictionary:dictionary];
    return msg;
}

@end
