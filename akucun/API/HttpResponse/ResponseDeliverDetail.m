//
//  ResponseDeliverDetail.m
//  akucun
//
//  Created by Jarry on 2017/6/25.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseDeliverDetail.h"
#import "AdOrderManager.h"

@implementation ResponseDeliverDetail

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    self.order = [AdOrder yy_modelWithDictionary:[jsonData objectForKey:@"adorder"]];
    
    NSMutableArray *array = [NSMutableArray array];
    for (CartProduct *product in self.order.products) {
        // 
        product.shuliang = 1;
        // 超出售后时间，修改商品状态
        if (self.order.outaftersale > 0) {
            product.outaftersale = YES;
        }
        product.isvirtual = self.order.isvirtual;
        //
        AdProductDB *p = [[AdProductDB alloc] initWithModel:product];
        /*
        AdProductDB *item = [[AdOrderManager instance] productById:product.cartproductid];
        if (item) {
            p.peihuo = item.peihuo;
        }
        product.isPeihuo = (p.peihuo > 0);
         */
        [array addObject:p];
    }
    
    // 保存 拣货中/已发货 的
    if (self.order.statu > 0) {
        // 保存 发货单详情
        [[AdOrderManager instance] saveAdOrder:self.order];
        // 保存 发货单商品
        [[AdOrderManager instance] saveProducts:array orderId:self.order.adorderid];
    }
}

@end
