//
//  CartProduct.h
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"
#import "ProductSKU.h"

// 订单商品状态
typedef NS_ENUM(NSInteger, eProductStatus)
{
    ProductStatusInit = 0 ,         // 初始态、未支付
    ProductStatusWeifahuo = 1 ,     // 已支付、未发货
    ProductStatusYifahuo = 2 ,      // 已发货
    ProductStatusFahuo = 3 ,        // 发货 处理中
    
    ProductStatusCancel = 4 ,       // 取消（未支付取消）
    ProductStatusQuehuo = 5 ,       // 平台缺货 退款中
    ProductStatusTuihuo = 6 ,       // 退货、已退款
    ProductStatusPending = 7 ,      // 退货退款 处理中
    ProductStatusTuikuan = 8 ,      // 用户取消 退款中
    
    ProductStatusTuikuanDone = 9 ,  // 用户取消 已退款
    ProductStatusQuehuoDone = 10 ,  // 平台缺货 已退款
//    ProductStatusResend = 11 ,      // 漏发已补发
//    ProudctStatusRefund = 12 ,      // 漏发已退款
    
    ProductASaleSubmit = 13 ,       // 售后 已提交 (审核中)
    ProductASaleRejected = 14 ,     // 售后 审核不通过
    ProductASalePending = 15 ,      // 售后 审核通过（售后处理中)
    ProductASaleLoufaBufa = 16 ,    // 售后 漏发已补发
    ProductASaleLoufaTuikuan = 17 , // 售后 漏发已退款
    ProductASaleTuihuoBufa = 18 ,   // 售后 退货已补发
    ProductASaleTuihuoTuikuan = 19, // 售后 退货已退款
    ProductASaleTuihuoPending = 20  // 售后 退货处理中
};


@interface CartProduct : JTModel

@property (nonatomic, copy) NSString *productid;
@property (nonatomic, copy) NSString *cartproductid;
@property (nonatomic, copy) NSString *barcode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pinpai;
@property (nonatomic, copy) NSString *pinpaiurl;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *tupianURL;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *danwei;
@property (nonatomic, copy) NSString *cunfangdi;
@property (nonatomic, copy) NSString *chima;
@property (nonatomic, copy) NSString *yanse;
@property (nonatomic, copy) NSString *kuanhao;
@property (nonatomic, copy) NSString *skuid;

@property (nonatomic, assign) NSTimeInterval buytimestamp;

@property (nonatomic, strong) ProductSKU *sku;

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger shuliang;
@property (nonatomic, assign) NSInteger diaopaijia;
@property (nonatomic, assign) NSInteger xiaoshoujia;
@property (nonatomic, assign) NSInteger jiesuanjia;

@property (nonatomic, assign) BOOL isvirtual;   // 是否是虚拟商品
@property (nonatomic, copy) NSString *extrainfo;

// 用于购物车回收列表， 2: 回收  3: 已复购
@property (nonatomic, assign) NSInteger buystatus;
// 扫码分拣 标记
@property (nonatomic, assign) NSInteger scanstatu;

@property (nonatomic, assign) BOOL quxiaogoumai;

@property (nonatomic, assign) BOOL outaftersale;

@property (nonatomic, copy) NSString *orderid;
@property (nonatomic, copy) NSString *adorderid;
@property (nonatomic, copy) NSString *xuhaostr;

@property (nonatomic, assign) BOOL showBarcode;

//@property (nonatomic, assign) BOOL isPeihuo;

- (NSString *) productDesc;

- (NSString *) imageUrl;
- (NSArray *) imagesUrl;

- (NSString *) statusText;

- (BOOL) quehuo;

- (NSString *) jiesuanPrice;

@end
