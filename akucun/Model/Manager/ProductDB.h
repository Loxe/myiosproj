//
//  ProductDB.h
//  akucun
//
//  Created by Jarry on 2017/4/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ProductModel.h"

@interface ProductDB : NSObject

//@property (nonatomic, copy) NSString *pkid;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *pinpai;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *json;

@property (nonatomic, assign) NSInteger xuhao;
@property (nonatomic, assign) NSInteger lastxuhao;

@property (nonatomic, assign) NSTimeInterval time;

@property (nonatomic, copy) NSString *liveId;
@property (nonatomic, copy) NSString *corpId;

@property (nonatomic, assign) NSInteger quehuo;

// 0 : 商品  1 : 上架结束内容
@property (nonatomic, assign) NSInteger pType;

// 已转发、已关注 标记
@property (nonatomic, assign) NSInteger forward;
@property (nonatomic, assign) NSInteger follow;


- (instancetype) initWithModel:(ProductModel *)product;

- (ProductModel *) productModel;

@end
