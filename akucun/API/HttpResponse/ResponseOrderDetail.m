//
//  ResponseOrderDetail.m
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseOrderDetail.h"
#import "CartProduct.h"

@implementation ResponseOrderDetail

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    self.order = [OrderModel yy_modelWithDictionary:[jsonData objectForKey:@"order"]];
    self.logistics = [Logistics yy_modelWithDictionary:[jsonData objectForKey:@"logistics"]];
    
    for (CartProduct *product in self.result) {
        // 超出售后时间，修改商品状态
        if (self.order.outaftersale > 0) {
            product.outaftersale = YES;
        }
        product.isvirtual = self.order.isvirtual;
    }

}

- (NSString *) resultKey
{
    return @"products";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    CartProduct *product = [CartProduct yy_modelWithDictionary:dictionary];
    product.shuliang = 1;
//    if (product.quxiaogoumai) {
//        return nil;
//    }
    return product;
}


@end
