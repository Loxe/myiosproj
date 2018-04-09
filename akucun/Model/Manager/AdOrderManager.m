//
//  AdOrderManager.m
//  akucun
//
//  Created by Jarry on 2017/7/23.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AdOrderManager.h"
#import "UserManager.h"

#define kTableAdOrder       @"adorder"
#define kTableAdProducts    @"adproducts"

@implementation AdOrderManager

+ (AdOrderManager *) instance
{
    static dispatch_once_t  onceToken;
    static AdOrderManager * instance;
    dispatch_once(&onceToken, ^{
        instance = [[AdOrderManager alloc] init];
    });
    return instance;
}

#pragma mark -

- (id) init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void) initData
{
    NSString *dbName = [UserManager instance].userId;
    _db = [JQFMDB shareDatabase:dbName];
    
    //
    if (![self.db jq_isExistTable:kTableAdOrder]) {
        [self.db jq_createTable:kTableAdOrder dicOrModel:[AdOrder class] excludeName:@[@"products"]];
        INFOLOG(@"--> DB : Create adorder table");
    }
    if (![self.db jq_isExistTable:kTableAdProducts]) {
        [self.db jq_createTable:kTableAdProducts dicOrModel:[AdProductDB class]];
    }
    
    //
    NSArray *columns = [self.db jq_columnNameArray:kTableAdOrder];
    if (columns.count > 0 && ![columns containsObject:@"barcodeconfig"]) {
        [self.db jq_alterTable:kTableAdOrder dicOrModel:[AdOrder class]];
    }
}

- (AdOrder *) adOrderById:(NSString *)adorderid
{
    NSArray *array = [self.db jq_lookupTable:kTableAdOrder dicOrModel:[AdOrder class] whereFormat:@"WHERE adorderid='%@'", adorderid];
    if (array.count > 0) {
        AdOrder *adOrder = array[0];
        //
        NSArray *products = [self getProductsBy:adorderid];
        adOrder.products = products;
        return adOrder;
    }
    return nil;
}

- (void) saveAdOrder:(AdOrder *)adorder
{
    @weakify(self)
    AdOrder *order = [self adOrderById:adorder.adorderid];
    if (order) {
        // 更新
        [self.db jq_inDatabase:^{
            @strongify(self)
            [self.db jq_updateTable:kTableAdOrder dicOrModel:adorder whereFormat:@"WHERE adorderid='%@'", adorder.adorderid];
        }];
    }
    else {
        [self.db jq_inDatabase:^{
            @strongify(self)
            [self.db jq_insertTable:kTableAdOrder dicOrModel:adorder];
        }];
    }
}

- (void) saveAdOrders:(NSArray *)orders
{
    if (orders.count == 0) {
        return;
    }

    @weakify(self)
    [self.db jq_inDatabase:^{
        @strongify(self)
        [self.db jq_insertTable:kTableAdOrder dicOrModelArray:orders];
    }];
}

- (NSArray *) getProductsBy:(NSString *)adorderid
{
    NSArray *dbs = [self.db jq_lookupTable:kTableAdProducts dicOrModel:[AdProductDB class] whereFormat:@"WHERE adorderid='%@'", adorderid];
    
    NSMutableArray *array = [NSMutableArray array];
    for (AdProductDB *db in dbs) {
        CartProduct *product = [db productModel];
        if (product) {
            [array addObject:product];
        }
    }
    
    return array;
}

- (NSArray *) productsByBarcode:(NSString *)barcode order:(NSString *)orderId
{
    NSArray *array = [self.db jq_lookupTable:kTableAdProducts dicOrModel:[AdProductDB class] whereFormat:@"WHERE adorderid='%@' AND barcode='%@'", orderId, barcode];
    if (array.count > 0) {
//        AdProductDB *db = array[0];
//        CartProduct *product = [db productModel];
        return array;
    }
    return nil;
}

- (AdProductDB *) productById:(NSString *)cartproductId
{
    NSArray *array = [self.db jq_lookupTable:kTableAdProducts dicOrModel:[AdProductDB class] whereFormat:@"WHERE cartproductid='%@'", cartproductId];
    if (array.count > 0) {
        return array[0];
    }
    return nil;
}

- (void) saveProducts:(NSArray *)products orderId:(NSString *)adOrderid
{
    if (products.count == 0) {
        return;
    }
    
    @weakify(self)
    [self.db jq_inDatabase:^{
        @strongify(self)
        [self.db jq_deleteTable:kTableAdProducts whereFormat:@"WHERE adorderid='%@'", adOrderid];
        [self.db jq_insertTable:kTableAdProducts dicOrModelArray:products];
    }];
}

- (void) updateProductStatus:(NSInteger)pkid
{
    [self.db jq_updateTable:kTableAdProducts
                 dicOrModel:@{ @"peihuo" : @(1) }
                whereFormat:@"WHERE pkid='%ld'", (long)pkid];
}

- (void) updateProductStatusBy:(NSString *)cartProductId
{
    [self.db jq_updateTable:kTableAdProducts
                 dicOrModel:@{ @"peihuo" : @(1) }
                whereFormat:@"WHERE cartproductid='%@'", cartProductId];
}

- (void) updateProductRemark:(NSString *)remark product:(NSString *)cartproductId
{
    [self.db jq_updateTable:kTableAdProducts
                 dicOrModel:@{ @"remark" : remark }
                whereFormat:@"WHERE cartproductid='%@'", cartproductId];
}

@end

@implementation AdProductDB

- (instancetype) initWithModel:(CartProduct *)product
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.adorderid = product.adorderid;
    self.productid = product.productid;
    self.cartproductid = product.cartproductid;
    self.remark = product.remark;
    self.desc = product.desc;
    self.barcode = product.sku.barcode;

    self.json = [product yy_modelToJSONString];
    
    self.peihuo = product.scanstatu; //product.isPeihuo ? 1 : 0;
    
    return self;
}

- (CartProduct *) productModel
{
    CartProduct *product = [CartProduct yy_modelWithJSON:self.json];
    product.remark = self.remark;
    product.scanstatu = self.peihuo;
    product.shuliang = 1;
    return product;
}

@end
