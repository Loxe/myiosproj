//
//  ResponseSKUList.m
//  akucun
//
//  Created by Jarry on 2017/8/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseSKUList.h"
#import "ProductsManager.h"

@implementation ResponseSKUList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];

    if (self.productId) {
        ProductModel *product = [[ProductsManager instance] productById:self.productId];
        if (!product) {
            return;
        }
        for (ProductSKU *sku in self.result) {
            [product updateSKU:sku];
        }
        [[ProductsManager instance] updateProduct:product];
        self.product = product;
    }
    else {
        for (ProductSKU *sku in self.result) {
            ProductModel *product = [[ProductsManager instance] productById:sku.productid];
            if (product) {
                [product updateSKU:sku];
                [[ProductsManager instance] updateProduct:product];
            }
        }
        
        if (self.productIds) {
            NSMutableArray *array = [NSMutableArray array];
            for (ProductModel *item in self.productIds) {
                ProductModel *p = [[ProductsManager instance] productById:item.Id];
                [array addObject:p];
            }
            self.products = array;
        }
    }
}

- (NSString *) resultKey
{
    return @"skus";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    ProductSKU *sku = [ProductSKU yy_modelWithDictionary:dictionary];
    return sku;
}

@end
