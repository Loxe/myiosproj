//
//  AdOrderManager.h
//  akucun
//
//  Created by Jarry on 2017/7/23.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JQFMDB.h"
#import "CartProduct.h"
#import "AdOrder.h"

@class AdProductDB;

/**
 发货单本地存储管理
 */
@interface AdOrderManager : NSObject

@property (nonatomic, strong) JQFMDB *db;


+ (AdOrderManager *) instance;

- (void) initData;

- (AdOrder *) adOrderById:(NSString *)adorderid;

- (void) saveAdOrder:(AdOrder *)adorder;

- (void) saveProducts:(NSArray *)products orderId:(NSString *)adOrderid;

- (NSArray *) getProductsBy:(NSString *)adorderid;

- (NSArray *) productsByBarcode:(NSString *)barcode order:(NSString *)orderId;

- (AdProductDB *) productById:(NSString *)cartproductId;

- (void) updateProductStatus:(NSInteger)pkid;

- (void) updateProductStatusBy:(NSString *)cartProductId;

- (void) updateProductRemark:(NSString *)remark product:(NSString *)cartproductId;

@end

@interface AdProductDB : NSObject

@property (nonatomic, assign) NSInteger pkid;

@property (nonatomic, copy) NSString *adorderid;
@property (nonatomic, copy) NSString *productid;
@property (nonatomic, copy) NSString *cartproductid;
@property (nonatomic, copy) NSString *barcode;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *json;

@property (nonatomic, assign) NSInteger peihuo;


- (instancetype) initWithModel:(CartProduct *)product;

- (CartProduct *) productModel;

@end

