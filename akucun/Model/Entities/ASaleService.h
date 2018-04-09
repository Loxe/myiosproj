//
//  ASaleService.h
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"
#import "ProductSKU.h"

// 订单商品状态
typedef NS_ENUM(NSInteger, eASaleStatus)
{
    ASaleStatusSubmit = 1 ,         // 已提交 (审核中)
    ASaleStatusRejected ,           // 审核不通过
    ASaleStatusPending ,            // 审核通过（售后处理中)
    ASaleStatusLoufaBufa ,          // 漏发 已补发
    ASaleStatusLoufaTuikuan ,       // 漏发 已退款
    ASaleStatusTuihuoBufa ,         // 退货 已补发
    ASaleStatusTuihuoTuikuan ,      // 退货 已退款
    ASaleStatusTuihuoPending ,      // 退货 处理中
    ASaleStatusCanceled = 10        // 已取消
};

@interface ASaleService : JTModel

@property (nonatomic, copy) NSString *cartproductid;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *tupianURL;
@property (nonatomic, copy) NSString *danwei;
@property (nonatomic, assign) NSInteger jiesuanjia;
@property (nonatomic, strong) ProductSKU *sku;

@property (nonatomic, copy) NSString *orderid;

@property (nonatomic, copy) NSString *servicehao;
@property (nonatomic, copy) NSString *shenqingshijian;
@property (nonatomic, copy) NSString *wentimiaoshu;
@property (nonatomic, copy) NSString *servicedesc;
@property (nonatomic, copy) NSString *pingzheng;

@property (nonatomic, assign) NSInteger servicetype;
@property (nonatomic, assign) NSInteger yuanyin;
@property (nonatomic, assign) NSInteger shouhouleixing;
@property (nonatomic, assign) NSInteger chulizhuangtai;

@property (nonatomic, copy) NSString *refundcorp;
@property (nonatomic, copy) NSString *refundhao;

@property (nonatomic, copy) NSString *reissuecorp;
@property (nonatomic, copy) NSString *reissuehao;


- (NSString *) productDesc;

- (NSString *) imageUrl;

- (NSString *) jiesuanPrice;

- (NSString *) pingzhengUrl;

- (NSString *) serviceTypeText;

- (NSString *) statusText;

- (UIColor *) statusColor;

@end
