//
//  ResponseLiveProducts.m
//  akucun
//
//  Created by Jarry Z on 2018/1/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseLiveProducts.h"
#import "ProductsManager.h"
#import "LiveManager.h"

@implementation ResponseLiveProducts

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    //
    self.period = [jsonData getIntegerValueForKey:@"period"];
    [LiveManager instance].periodTime = self.period;

    //
    [[ProductsManager instance] insertProducts:self.result];
}

- (NSString *) resultKey
{
    return @"products";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    ProductModel *product = [ProductModel yy_modelWithDictionary:dictionary];
    return product;
}

- (void) showLog
{
    INFOLOG(@"--> Synced Products : %ld , time : %ld", (long)self.result.count, (long)self.period);
}

@end
