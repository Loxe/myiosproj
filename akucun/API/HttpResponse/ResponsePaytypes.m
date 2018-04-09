//
//  ResponsePaytypes.m
//  akucun
//
//  Created by Jarry on 2017/6/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponsePaytypes.h"

@implementation ResponsePaytypes

- (NSArray *) validPayTypes
{
    /*
    NSArray *array = [self.result sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PayType *p1 = obj1;
        PayType *p2 = obj2;
        NSNumber *number1 = @(p1.paytype);
        NSNumber *number2 = @(p2.paytype);
        NSComparisonResult result = [number1 compare:number2];
        return (result == NSOrderedAscending);
    }];
    
    NSMutableArray *result = [NSMutableArray array];
    for (PayType *item in array) {
        if (item.flag > 0) {
            [result addObject:item];
        }
    }*/
    return self.result;
}

- (NSString *) resultKey
{
    return @"paytype";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    PayType *payType = [PayType yy_modelWithDictionary:dictionary];
    return payType;
}

@end
