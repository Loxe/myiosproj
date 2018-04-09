//
//  ResponseFollowList.m
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseFollowList.h"
#import "ProductsManager.h"

@implementation ResponseFollowList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    self.products = [NSMutableArray array];
    
    for (NSString *productId in self.result) {
        ProductModel *product = [[ProductsManager instance] productById:productId];
        if (product) {
            product.follow = 1;
            [self.products addObject:product];
            // 
            [[ProductsManager instance] updateProductFollow:product];
        }
    }
}

- (NSString *) resultKey
{
    return @"products";
}

- (NSMutableArray *) getResultFrom:(id)datas
{
    NSArray *array = [datas objectForKey:[self resultKey]];
    return [NSMutableArray arrayWithArray:array];
}

@end
