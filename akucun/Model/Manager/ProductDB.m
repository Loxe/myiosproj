//
//  ProductDB.m
//  akucun
//
//  Created by Jarry on 2017/4/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ProductDB.h"

@implementation ProductDB

- (instancetype) initWithModel:(ProductModel *)product
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.productId = product.Id;
    self.pinpai = product.pinpaiid;
    self.desc = product.desc;
    self.xuhao = product.xuhao;
    self.time = product.updateTime;
    self.json = [product yy_modelToJSONString];
    
    self.liveId = product.liveid;
    self.corpId = product.corpid;
    
    self.quehuo = [product isQuehuo] ? 1 : 0;
    
    self.pType = 0;
    if (!product.skus || product.skus.count == 0) {
        self.pType = 1;
    }
    
    self.forward = product.forward;
    self.follow = product.follow;
    
    self.lastxuhao = product.lastxuhao;
    if (self.lastxuhao == 0) {
        self.lastxuhao = product.xuhao;
    }
    
    return self;
}

- (ProductModel *) productModel
{
    ProductModel *p = [ProductModel yy_modelWithJSON:self.json];
    p.forward = self.forward;
    p.follow = self.follow;
    return p;
}

@end
