//
//  ProductsManager.h
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ProductModel.h"
#import "JQFMDB.h"
#import "LiveManager.h"

#define kProductPageCount   10  // 每次(页)加载的数量

//#define UDK_COMMENT_UPDATE  @"UDK_COMMENT_UPDATE"   //
//#define UDK_SKU_UPDATE      @"UDK_SKU_UPDATE"       //
#define UDK_FORWARD_DATA        @"UDK_FORWARD_DATA"         //
#define UDK_SKU_UPDATE_DATA     @"UDK_SKU_UPDATE_DATA"      //


@interface ProductsManager : NSObject

//@property (nonatomic, strong) NSMutableArray  *products;

//@property (nonatomic, assign) NSTimeInterval syncTime;

//@property (nonatomic, assign) NSTimeInterval productUpdate;
//@property (nonatomic, assign) NSTimeInterval commentUpdate;
//@property (nonatomic, assign) NSTimeInterval skuUpdate;

@property (nonatomic, strong) JQFMDB *db;

// 当前快速转发的品牌索引
@property (nonatomic, assign) NSInteger forwardPinpai;
// 快速转发记录 保存
@property (nonatomic, strong) NSDictionary *forwardData;

// SKU 跟踪时间保存，根据活动ID
@property (nonatomic, strong) NSDictionary *skuUpdateData;

@property (nonatomic, assign) NSInteger followCount;


+ (NSArray *) loadProductsStartWith:(NSInteger)index liveId:(NSString *)liveId;

//+ (BOOL) shouldSync;

+ (BOOL) hasMore:(NSInteger)index;

+ (void) syncProductsWith:(NSString *)liveId finished:(idBlock)finished failed:(voidBlock)failed;

+ (NSArray *) searchProductsBy:(NSString *)key liveId:(NSString *)liveId startWith:(NSInteger)index;

+ (NSArray *) searchQuehuoProductsWith:(NSInteger)index liveId:(NSString *)liveId;
+ (NSArray *) searchYouhuoProductsWith:(NSInteger)index liveId:(NSString *)liveId;

+ (void) clearHistoryData;

//
+ (NSTimeInterval) skuTimeByLive:(NSString *)liveId;
+ (void) updateSkuTime:(NSTimeInterval)updateTime live:(NSString *)liveId;

// 读取快速转发的商品
+ (ProductModel *) getForwardProduct:(NSInteger)xuhao;
+ (NSInteger) getForwardIndex;
+ (void) updateForwardIndex:(NSInteger)xuhao;
+ (NSInteger) updateNextValidIndex:(NSInteger)xuhao;
+ (NSInteger) updatePrevValidIndex:(NSInteger)xuhao;
+ (LiveInfo *) getForwardLive;

+ (void) init;

+ (ProductsManager *) instance;

- (void) initData;

- (void) createProductTable;

- (ProductModel *) productById:(NSString *)pId;

- (void) updateProduct:(ProductModel *)product;

- (BOOL) isProductExist:(NSString *)pId;
- (void) insertProducts:(NSArray *)products;

- (void) deleteDataById:(NSString *)productId;

- (void) deleteDataByLive:(NSString *)liveId;

- (void) updateProductFollow:(ProductModel *)product;
- (void) updateProductForward:(ProductModel *)product;

@end
