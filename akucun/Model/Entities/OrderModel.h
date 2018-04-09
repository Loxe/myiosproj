//
//  OrderModel.h
//  akucun
//
//  Created by Jarry on 2017/4/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface OrderModel : JTModel

@property (nonatomic, copy) NSString *orderid;
@property (nonatomic, copy) NSString *dingdanshijian;

@property (nonatomic, copy) NSString *pinpai;
@property (nonatomic, copy) NSString *pinpaiURL;

@property (nonatomic, copy) NSString *downloadurl;

@property (nonatomic, copy) NSString *jiesuanfangshi;
@property (nonatomic, assign) NSInteger jiesuanfangshishuzi;

@property (nonatomic, assign) NSTimeInterval dingdanshijianshuzi;
@property (nonatomic, assign) NSTimeInterval overtimeshuzi;

@property (nonatomic, assign) NSInteger shangpinjianshu;
@property (nonatomic, assign) NSInteger shangpinjine;
@property (nonatomic, assign) NSInteger zongjine;

@property (nonatomic, assign) NSInteger yunfei;
@property (nonatomic, assign) NSInteger dikoujine;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger outaftersale; // > 0 超出售后时间

@property (nonatomic, copy) NSString *wuliugongsi;
@property (nonatomic, copy) NSString *wuliuhao;

@property (nonatomic, assign) BOOL isvirtual;   // 是否是虚拟商品

- (NSString *) displayOrderId;

- (NSString *) dateString;

- (NSString *) statusText;

- (UIColor *) statusColor;

- (NSString *) totalAmount;

@end
