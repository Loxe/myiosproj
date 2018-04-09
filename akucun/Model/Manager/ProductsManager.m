//
//  ProductsManager.m
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ProductsManager.h"
#import "ProductDB.h"
#import "UserManager.h"
#import "RequestLiveProducts.h"

#define kTableProduct   @"product"


@implementation ProductsManager
/*
+ (BOOL) shouldSync
{
    NSTimeInterval productUpdate = [ProductsManager instance].productUpdate;
    if (productUpdate <= 0) {
        return YES;
    }
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval sync = [ProductsManager instance].syncTime;
    NSTimeInterval delta = now - sync;
    if (delta > 3600) {
        return YES;
    }
    return NO;
}*/

+ (void) syncProductsWith:(NSString *)liveId finished:(idBlock)finished failed:(voidBlock)failed
{
    [[ProductsManager instance] syncProductsWith:liveId finished:finished failed:failed];
}

+ (NSArray *) loadProductsStartWith:(NSInteger)index liveId:(NSString *)liveId
{
    return [[ProductsManager instance] getProductsStartWith:index liveId:liveId];
}

+ (BOOL) hasMore:(NSInteger)index
{
    NSInteger total = [[ProductsManager instance] getTotal];
    return (index < total);
}

+ (NSArray *) searchProductsBy:(NSString *)key liveId:(NSString *)liveId startWith:(NSInteger)index
{
    return [[ProductsManager instance] searchProductsBy:key liveId:liveId startWith:index];
}

+ (NSArray *) searchQuehuoProductsWith:(NSInteger)index liveId:(NSString *)liveId
{
    return [[ProductsManager instance] searchQuehuoProductsWith:index liveId:liveId quehuo:YES];
}

+ (NSArray *) searchYouhuoProductsWith:(NSInteger)index liveId:(NSString *)liveId
{
    return [[ProductsManager instance] searchQuehuoProductsWith:index liveId:liveId quehuo:NO];
}

+ (void) clearHistoryData
{
    [[ProductsManager instance] deleteHistoryData];
    //
//    [ProductsManager instance].productUpdate = 0;
//    [ProductsManager instance].commentUpdate = 0;
//    [ProductsManager instance].skuUpdate = 0;
    
//    [USER_DEFAULT removeObjectForKey:UDK_COMMENT_UPDATE];
//    [USER_DEFAULT removeObjectForKey:UDK_SKU_UPDATE];
    [USER_DEFAULT synchronize];
}

+ (NSTimeInterval) skuTimeByLive:(NSString *)liveId
{
    return [[ProductsManager instance].skuUpdateData getDoubleValueForKey:liveId];
}

+ (void) updateSkuTime:(NSTimeInterval)updateTime live:(NSString *)liveId
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ProductsManager instance].skuUpdateData];
    [dic setObject:@(updateTime) forKey:liveId];
    [ProductsManager instance].skuUpdateData = dic;
    
    [USER_DEFAULT setObject:[ProductsManager instance].skuUpdateData forKey:UDK_SKU_UPDATE_DATA];
    [USER_DEFAULT synchronize];
}

+ (ProductModel *) getForwardProduct:(NSInteger)xuhao
{
    NSInteger pinpaiIndex = [ProductsManager instance].forwardPinpai;
    LiveInfo *liveInfo = [LiveManager liveInfoAtIndex:pinpaiIndex];

    NSInteger index = xuhao;
    if (xuhao == 0) {
        index = [ProductsManager getForwardIndex];
    }
  
    ProductModel *product = [[ProductsManager instance] searchProductByXuhao:(index) live:liveInfo.liveid];

    return product;
}

+ (NSInteger) getForwardIndex
{
    NSInteger pinpaiIndex = [ProductsManager instance].forwardPinpai;
    LiveInfo *liveInfo = [LiveManager liveInfoAtIndex:pinpaiIndex];
    if (!liveInfo) {
        return 0;
    }
    NSInteger index = [[ProductsManager instance].forwardData getIntegerValueForKey:liveInfo.liveid];
    if (index <= 0) {
        ProductDB *p = [[ProductsManager instance] getFirstProductByLive:liveInfo.liveid];
        if (!p) {
            return 0;
        }
        return p.xuhao;
    }
    return index;
}

+ (void) updateForwardIndex:(NSInteger)xuhao
{
    NSInteger pinpaiIndex = [ProductsManager instance].forwardPinpai;
    LiveInfo *liveInfo = [LiveManager liveInfoAtIndex:pinpaiIndex];
    
    NSInteger index = xuhao;
    if (xuhao == 0) {
        index = [ProductsManager getForwardIndex];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ProductsManager instance].forwardData];
    [dic setObject:@(index) forKey:liveInfo.liveid];
    [ProductsManager instance].forwardData = dic;
    
    [USER_DEFAULT setObject:[ProductsManager instance].forwardData forKey:UDK_FORWARD_DATA];
    [USER_DEFAULT synchronize];
}

+ (NSInteger) updateNextValidIndex:(NSInteger)xuhao
{
    NSInteger pinpaiIndex = [ProductsManager instance].forwardPinpai;
    LiveInfo *liveInfo = [LiveManager liveInfoAtIndex:pinpaiIndex];
    
    ProductDB *p = [[ProductsManager instance] getLastProductByLive:liveInfo.liveid];
    NSInteger lastXuhao = p.xuhao;
    if (p && xuhao >= lastXuhao) {
        return xuhao;
    }
    
    NSInteger index = xuhao + 1;
    ProductModel *product = [ProductsManager getForwardProduct:index];
    while ((!product && index < lastXuhao) || (product && [product forwardDisabled])) {
        index ++;
        product = [ProductsManager getForwardProduct:index];
    }
    
    if (!product) {
        return xuhao;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ProductsManager instance].forwardData];
    [dic setObject:@(index) forKey:liveInfo.liveid];
    [ProductsManager instance].forwardData = dic;
    
    [USER_DEFAULT setObject:[ProductsManager instance].forwardData forKey:UDK_FORWARD_DATA];
    [USER_DEFAULT synchronize];
    
    return index;
}

+ (NSInteger) updatePrevValidIndex:(NSInteger)xuhao
{
    NSInteger pinpaiIndex = [ProductsManager instance].forwardPinpai;
    LiveInfo *liveInfo = [LiveManager liveInfoAtIndex:pinpaiIndex];
    
    if (xuhao <= 1) {
        return xuhao;
    }
    
    NSInteger index = xuhao - 1;
    ProductModel *product = [ProductsManager getForwardProduct:index];
    while ((!product && index > 1) || (product && [product forwardDisabled])) {
        index --;
        product = [ProductsManager getForwardProduct:index];
    }
    
    if (!product) {
        return xuhao;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ProductsManager instance].forwardData];
    [dic setObject:@(index) forKey:liveInfo.liveid];
    [ProductsManager instance].forwardData = dic;
    
    [USER_DEFAULT setObject:[ProductsManager instance].forwardData forKey:UDK_FORWARD_DATA];
    [USER_DEFAULT synchronize];
    
    return index;
}

+ (LiveInfo *) getForwardLive
{
    NSInteger pinpaiIndex = [ProductsManager instance].forwardPinpai;
    return [LiveManager liveInfoAtIndex:pinpaiIndex];
}

+ (void) init
{
    [[ProductsManager instance] initData];
}

+ (ProductsManager *) instance
{
    static dispatch_once_t  onceToken;
    static ProductsManager * instance;
    dispatch_once(&onceToken, ^{
        instance = [[ProductsManager alloc] init];
    });
    return instance;
}

#pragma mark -

- (id) init
{
    self = [super init];
    if (self) {
//        _products = [NSMutableArray array];
        _forwardPinpai = -1;
    }
    return self;
}

- (void) initData
{
#ifndef APPSTORE    // 企业版
    NSString *dbName = @"akucun.sqlite";
#else
    NSString *dbName = @"akucunApp.sqlite";
#endif
    
#if DEBUG
    dbName = @"akucunBeta.sqlite";
#endif
    
    _db = [JQFMDB shareDatabase:dbName];

    if ([self.db jq_isExistTable:kTableProduct]) {
        //
        NSArray *columns = [self.db jq_columnNameArray:kTableProduct];
        if (columns.count > 0 && ![columns containsObject:@"lastxuhao"]) {
            [self.db jq_alterTable:kTableProduct dicOrModel:[ProductDB class]];
        }

        // 删除7天前的数据
        [self deleteOldData];
        
        // 获取最新一条数据
//        ProductDB *p = [self getLastProduct];
//        if (p) {
//            self.productUpdate = p.time;
//        }
    }
    else {
        [self.db jq_createTable:kTableProduct dicOrModel:[ProductDB class]];
    }

    /*
    NSNumber *commentUpdate = [USER_DEFAULT objectForKey:UDK_COMMENT_UPDATE];
    if (commentUpdate) {
        self.commentUpdate = [commentUpdate doubleValue];
    }
    
    NSNumber *skuUpdate = [USER_DEFAULT objectForKey:UDK_SKU_UPDATE];
    if (skuUpdate) {
        self.skuUpdate = [skuUpdate doubleValue];
    }*/
    
    //
    self.forwardData = [USER_DEFAULT objectForKey:UDK_FORWARD_DATA];
    if (!self.forwardData) {
        self.forwardData  = [NSDictionary dictionary];
    }
    
    self.skuUpdateData = [USER_DEFAULT objectForKey:UDK_SKU_UPDATE_DATA];
    if (!self.skuUpdateData) {
        self.skuUpdateData  = [NSDictionary dictionary];
    }
}

- (void) createProductTable
{
    if (![self.db jq_isExistTable:kTableProduct]) {
        [self.db jq_createTable:kTableProduct dicOrModel:[ProductDB class]];
    }
}

- (void) dealloc
{
    [self.db close];
}

- (void) syncProductsWith:(NSString *)liveId finished:(idBlock)finished failed:(voidBlock)failed
{
    /*
    NSString *overLives = [LiveManager instance].overLiveIds;
    if (overLives && overLives.length > 0) {
        NSArray *array = [overLives componentsSeparatedByString:@","];
        for (NSString *liveId in array) {
            [self deleteDataByLive:liveId];
        }
        [LiveManager instance].overLiveIds = nil;
    }*/
    
    //
    [self createProductTable];
    
    RequestLiveProducts *request = [RequestLiveProducts new];
    request.liveid = liveId;
    
    ProductDB *p = [self getMaxProductByLive:liveId];
    if (p) {
        request.lastxuhao = p.lastxuhao;
    }
    
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         if (finished) {
             ResponseLiveProducts *response = content;
             finished(response.result);
         }
     }
                                 onFailed:^(id content)
     {
         if (failed) {
             failed();
         }
     }
                                  onError:^(id content)
     {
         if (failed) {
             failed();
         }
     }];
}
/*
- (void) requestSyncPorducts:(double)time
{
    RequestSyncProducts *request = [RequestSyncProducts new];
    request.sync = time;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseSyncProducts *response = content;
         if (response.lastupdate > self.productUpdate) {
             self.productUpdate = response.lastupdate;
         }
         
         //
         [self saveProductsToDB:response.products];
         
         [self.products addObjectsFromArray:response.result];
         
         if (response.hasMore) {
             [self requestSyncPorducts:response.lastupdate];
         }
         else {
             [self requestSyncComments:self.commentUpdate];
         }
         
     }
                                 onFailed:^(id content)
     {
         if (self.failedBlock) {
             self.failedBlock();
         }
     }
                                  onError:^(id content)
     {
         if (self.failedBlock) {
             self.failedBlock();
         }
     }];
}

- (void) requestSyncComments:(double)time
{
    RequestSyncComments *request = [RequestSyncComments new];
    request.sync = time;
    [SCHttpServiceFace serviceWithRequest:request
                                onSuccess:^(id content)
     {
         ResponseSyncComments *response = content;
         self.commentUpdate = response.lastupdate;
//         [self updateComments:response.result];
         if (response.hasMore) {
             [self requestSyncComments:response.lastupdate];
         }
         else {
             if (self.finishedBlock) {
                 self.finishedBlock();
             }
         }
     }
                                 onFailed:^(id content)
     {
         if (self.failedBlock) {
             self.failedBlock();
         }
     }
                                  onError:^(id content)
     {
         if (self.failedBlock) {
             self.failedBlock();
         }
     }];
}
*/
- (BOOL) isProductExist:(NSString *)pId
{
    NSArray *array = [self.db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:FORMAT(@"WHERE productId='%@'", pId)];
    return (array.count > 0);
}

- (ProductModel *) productById:(NSString *)pId
{
    NSArray *array = [self.db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:FORMAT(@"WHERE productId='%@'", pId)];
    if (array.count > 0) {
        ProductDB *p = array[0];
        return [p productModel];
    }
    return nil;
}

- (ProductDB *) getLastProduct
{
    NSArray *array = [_db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:@"ORDER BY time DESC LIMIT 1"];
    if (array.count > 0) {
        return array[0];
    }
    return nil;
}

- (ProductDB *) getLastProductByLive:(NSString *)liveId
{
    NSArray *array = [_db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:@"WHERE liveId='%@' AND pType='0' ORDER BY time DESC LIMIT 1", liveId];
    if (array.count > 0) {
        return array[0];
    }
    return nil;
}

- (ProductDB *) getFirstProductByLive:(NSString *)liveId
{
    NSArray *array = [_db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:@"WHERE liveId='%@' AND pType='0' ORDER BY time ASC LIMIT 1", liveId];
    if (array.count > 0) {
        return array[0];
    }
    return nil;
}

- (ProductDB *) getMaxProductByLive:(NSString *)liveId
{
    NSArray *array = [_db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:@"WHERE liveId='%@' ORDER BY lastxuhao DESC LIMIT 1", liveId];
    if (array.count > 0) {
        return array[0];
    }
    return nil;
}

- (void) updateProduct:(ProductModel *)product
{
    ProductDB *p = [[ProductDB alloc] initWithModel:product];
    @weakify(self)
    [self.db jq_inDatabase:^{
        @strongify(self)
        [self.db jq_updateTable:kTableProduct
                     dicOrModel:@{ @"quehuo" : @(p.quehuo),
                                   @"json" : p.json }
                    whereFormat:FORMAT(@"WHERE productId='%@'", product.Id)];
    }];
}

- (void) insertProducts:(NSArray *)products
{
    NSMutableArray *dbArray = [NSMutableArray array];
    for (ProductModel *product in products) {
        if ([self isProductExist:product.Id]) {
            continue;
        }
        ProductDB *db = [[ProductDB alloc] initWithModel:product];
        [dbArray addObject:db];
    }
    if (dbArray.count > 0) {
        [self saveProductsToDB:dbArray];
    }
}

- (NSArray *) getProductsStartWith:(NSInteger)index liveId:(NSString *)liveId
{
    NSInteger total = [self.db jq_tableItemCount:kTableProduct];
    if (index >= total) {
        return nil;
    }
    
    NSInteger count = kProductPageCount;
    NSInteger remain = total - index;
    if (remain < count) {
        count = remain;
    }
    
    NSMutableString *format = [NSMutableString string];
    if (liveId && liveId.length > 0) {
        [format appendFormat:@"WHERE liveId='%@' ", liveId];
    }

    [format appendFormat:@"ORDER BY time DESC LIMIT %ld,%ld", (long)index, (long)count];
    
    NSArray *dbs = [self.db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:format];
    
    NSMutableArray *array = [NSMutableArray array];
    for (ProductDB *db in dbs) {
        ProductModel *product = [db productModel];
        if (product) {
            [array addObject:product];
        }
    }
    
    return array;
}

- (NSInteger) getTotal
{
    return [self.db jq_tableItemCount:kTableProduct];
}

- (void) saveProductsToDB:(NSArray *)products
{
    if (products.count == 0) {
        return;
    }
    
    //
//    if (![self.db jq_isExistTable:kTableProduct]) {
//        [self.db jq_createTable:kTableProduct dicOrModel:[ProductDB class]];
//    }
    
    @weakify(self)
    [self.db jq_inDatabase:^{
        @strongify(self)
        [self.db jq_insertTable:kTableProduct dicOrModelArray:products];
    }];
    
//    NSLog(@"DB count : %ld", (long)[self getTotal]);
}
/*
- (void) setCommentUpdate:(NSTimeInterval)commentUpdate
{
    _commentUpdate = commentUpdate;
    
    [USER_DEFAULT setObject:@(commentUpdate) forKey:UDK_COMMENT_UPDATE];
    [USER_DEFAULT synchronize];
}

- (void) setSkuUpdate:(NSTimeInterval)skuUpdate
{
    _skuUpdate = skuUpdate;
    
    [USER_DEFAULT setObject:@(skuUpdate) forKey:UDK_SKU_UPDATE];
    [USER_DEFAULT synchronize];
}*/

// 删除 7天前的数据
- (void) deleteOldData
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(-3600 * 24 * 7)];
    
    NSTimeInterval time = [date timeIntervalSince1970];
    
    [self.db jq_deleteTable:kTableProduct whereFormat:FORMAT(@"WHERE time<%f",time)];
}

// 删除历史数据
- (void) deleteHistoryData
{
    [self.db jq_deleteAllDataFromTable:kTableProduct];
    [self.db jq_deleteTable:kTableProduct];
    //
    [USER_DEFAULT removeObjectForKey:UDK_SKU_UPDATE_DATA];
    [USER_DEFAULT synchronize];
    /*
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *date = [calendar dateFromComponents:components];
    
    NSTimeInterval time = [date timeIntervalSince1970];
    
    [self.db jq_deleteTable:kTableProduct whereFormat:FORMAT(@"WHERE time<%f",time)];*/
}

- (void) deleteDataByLive:(NSString *)liveId
{
    [self.db jq_deleteTable:kTableProduct whereFormat:@"WHERE liveId='%@'",liveId];
}

- (void) deleteDataById:(NSString *)productId
{
    [self.db jq_deleteTable:kTableProduct whereFormat:@"WHERE productId='%@'",productId];
}

- (NSArray *) searchProductsBy:(NSString *)key liveId:(NSString *)liveId startWith:(NSInteger)index
{
    NSArray *dbs = nil;
    if (liveId && liveId.length > 0) {
        dbs = [self.db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:@"WHERE desc LIKE '%%%@%%' AND pType='0' AND liveId='%@' ORDER BY time DESC LIMIT %ld,10", key, liveId, (long)index];
    }
    else {
        dbs = [self.db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:@"WHERE desc LIKE '%%%@%%' AND pType='0' ORDER BY time DESC LIMIT %ld,10", key, (long)index];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (ProductDB *db in dbs) {
        ProductModel *product = [db productModel];
        if (product) {
            [array addObject:product];
        }
    }
    
    return array;
}

- (ProductModel *) searchProductByXuhao:(NSInteger)xuhao
{
    NSArray *dbs = [self.db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:@"WHERE xuhao = '%ld' AND pType='0' ORDER BY time DESC", (long)xuhao];

    ProductModel *product = nil;
    if (dbs && dbs.count > 0) {
        product = [dbs[0] productModel];
    }
    return product;
}

- (ProductModel *) searchProductByXuhao:(NSInteger)xuhao live:(NSString *)liveId
{
    NSArray *dbs = [self.db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:@"WHERE xuhao = '%ld' AND pType='0' AND liveId = '%@' ORDER BY time DESC", (long)xuhao, liveId];
    
    ProductModel *product = nil;
    if (dbs && dbs.count > 0) {
        product = [dbs[0] productModel];
    }
    return product;
}

- (NSArray *) searchQuehuoProductsWith:(NSInteger)index liveId:(NSString *)liveId quehuo:(BOOL)quehuo
{
    NSMutableString *format = [NSMutableString string];
    [format appendFormat:@"WHERE quehuo='%d' AND pType='0' ", quehuo ? 1 : 0];
    if (liveId && liveId.length > 0) {
        [format appendFormat:@"AND liveId='%@' ", liveId];
    }
    [format appendFormat:@"ORDER BY time DESC LIMIT %ld,10",  (long)index];
    
    NSArray *dbs = [self.db jq_lookupTable:kTableProduct dicOrModel:[ProductDB class] whereFormat:format];
    
    NSMutableArray *array = [NSMutableArray array];
    for (ProductDB *db in dbs) {
        ProductModel *product = [db productModel];
        if (product) {
            [array addObject:product];
        }
    }
    
    return array;
}

- (void) updateProductFollow:(ProductModel *)product
{
    @weakify(self)
    [self.db jq_inDatabase:^{
        @strongify(self)
        [self.db jq_updateTable:kTableProduct
                     dicOrModel:@{ @"follow" : @(product.follow) }
                    whereFormat:FORMAT(@"WHERE productId='%@'", product.Id)];
    }];
}

- (void) updateProductForward:(ProductModel *)product
{
    @weakify(self)
    [self.db jq_inDatabase:^{
        @strongify(self)
        [self.db jq_updateTable:kTableProduct
                     dicOrModel:@{ @"forward" : @(product.forward) }
                    whereFormat:FORMAT(@"WHERE productId='%@'", product.Id)];
    }];
}

@end
