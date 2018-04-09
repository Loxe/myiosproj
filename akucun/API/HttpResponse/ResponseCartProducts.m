//
//  ResponseCartProducts.m
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseCartProducts.h"

@implementation ResponseCartProducts

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    self.outofstock = [NSMutableArray array];
    NSArray *outofstock = [jsonData objectForKey:@"outofstock"];
    for (NSDictionary *itemDic in outofstock) {
        CartProduct *product = [CartProduct yy_modelWithDictionary:itemDic];
        [self.outofstock addObject:product];
    }
/*
    NSComparator cmptr = ^(id obj1, id obj2){
        CartProduct *p1 = obj1;
        CartProduct *p2 = obj2;
        if (p1.buytimestamp < p2.buytimestamp) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (p1.buytimestamp > p2.buytimestamp) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray *array = [self.result sortedArrayUsingComparator:cmptr];
    self.result = [NSMutableArray arrayWithArray:array];*/
}
     
- (NSString *) resultKey
{
    return @"pgs";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    PinpaiCart *product = [PinpaiCart yy_modelWithDictionary:dictionary];
    return product;
}

@end
