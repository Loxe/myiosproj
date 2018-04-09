//
//  ProductModel.h
//  akucun
//
//  Created by Jarry on 2017/3/30.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"
#import "ProductSKU.h"
#import "Comment.h"

// 促销活动类型
typedef NS_ENUM(NSInteger, eSaleType)
{
    SalesTypeNone ,     // 无活动
    SalesTypeDouble ,   // 代购费翻倍活动
};

@interface ProductModel : JTModel

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pinpai;
@property (nonatomic, copy) NSString *pinpaiid;
@property (nonatomic, copy) NSString *pinpaiurl;
@property (nonatomic, copy) NSString *danwei;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *tupianURL;
@property (nonatomic, copy) NSString *kuanhao;
@property (nonatomic, copy) NSString *jijie;

@property (nonatomic, copy) NSString *liveid;
@property (nonatomic, copy) NSString *corpid;

@property (nonatomic, assign) NSInteger xuhao;
@property (nonatomic, assign) NSInteger lastxuhao;  // 内部序号

@property (nonatomic, assign) NSInteger diaopaijia;
@property (nonatomic, assign) NSInteger xiaoshoujia;
@property (nonatomic, assign) NSInteger jiesuanjia;

@property (nonatomic, assign) NSInteger bohuojia;   // 播货价格

@property (nonatomic, assign) NSTimeInterval updateTime;

@property (nonatomic, strong) NSArray *skus;

@property (nonatomic, strong) NSArray *comments;

@property (nonatomic, assign) NSInteger forward;
@property (nonatomic, assign) NSInteger follow;

@property (nonatomic, assign) BOOL isvirtual;       // 是否虚拟商品
@property (nonatomic, assign) NSInteger salestype;  // 促销活动类型 0:无活动 1:代购费翻倍活动


- (NSArray *) imagesUrl;

- (NSString *) imageUrl1;

- (NSString *) jiesuanPrice;

- (void) addComment:(Comment *)comment;

- (void) removeComment:(Comment *)comment;

- (void) updateSKU:(ProductSKU *)sku;

- (NSString *) weixinDesc;

- (NSString *) productDesc;

- (BOOL) isQuehuo;

- (BOOL) isQuehuo:(ProductSKU *)sku;

- (BOOL) shouldUpdateSKU;

- (BOOL) canbeForward;  //是否支持转发缺货尺码

- (BOOL) forwardDisabled;

- (void) loadImageUrls;

@end
