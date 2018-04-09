//
//  ResponseTrackSku.m
//  akucun
//
//  Created by Jarry Z on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseTrackSku.h"
#import "ProductsManager.h"

@implementation ResponseTrackSku

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    //
    self.lastupdate = [jsonData getDoubleValueForKey:@"lastupdate"];
    if (self.lastupdate > 0) {
        [ProductsManager updateSkuTime:self.lastupdate live:self.liveid];
    }
    
    self.period = [jsonData getIntegerValueForKey:@"period"];
    [LiveManager instance].skuPeriod = self.period;
    
    for (ProductSKU *sku in self.result) {
        ProductModel *product = [[ProductsManager instance] productById:sku.productid];
        if (product) {
            [product updateSKU:sku];
            //
            [[ProductsManager instance] updateProduct:product];
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

//- (void) showLog
//{
//    INFOLOG(@"--> Synced Products : %ld , time : %ld", (long)self.result.count, (long)self.period);
//}

@end
