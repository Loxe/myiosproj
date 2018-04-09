//
//  HttpResponseList.m
//  akucun
//
//  Created by Jarry on 14-7-2.
//  Copyright (c) 2014年 Sucang. All rights reserved.
//

#import "HttpResponseList.h"

@implementation HttpResponseList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    self.result = [self getResultFrom:jsonData];
}

- (NSString *) resultKey
{
    return @"list";
}

- (NSMutableArray *) getResultFrom:(id)datas
{
    NSArray *array = nil;
    if ([datas isKindOfClass:[NSDictionary class]]) {
        array = [datas objectForKey:[self resultKey]];
    }
    else if ([datas isKindOfClass:[NSArray class]]) {
        array = datas;
    }
    
    if (!array || [array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    }
    
    NSMutableArray *arrayResult = [NSMutableArray array];
    for (NSInteger i = 0 , total = [array count]; i < total; ++i) {
        NSDictionary *itemDic = (NSDictionary *) [array objectAtIndex:i];
        if ((NSObject *)itemDic == [NSNull null]) {
            continue;
        }
        id item = [self parseItemFrom:itemDic];
        if (item) {
            [arrayResult addObject:item];
        }
    }
    return arrayResult;
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    return nil;
}

- (void) addResultList:(NSArray *)list
{
    [self.result addObjectsFromArray:list];
}

- (BOOL) didReachEnd
{
    return (self.page >= self.pages);
}

@end
