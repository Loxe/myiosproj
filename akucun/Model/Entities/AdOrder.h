//
//  AdOrder.h
//  akucun
//
//  Created by Jarry on 2017/6/25.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface AdOrder : JTModel

@property (nonatomic, copy) NSString *adorderid;
@property (nonatomic, copy) NSString *odorderstr;

@property (nonatomic, copy) NSString *wuliugongsi;
@property (nonatomic, copy) NSString *wuliuhao;
@property (nonatomic, copy) NSString *shouhuoren;
@property (nonatomic, copy) NSString *lianxidianhua;
@property (nonatomic, copy) NSString *shouhuodizhi;

@property (nonatomic, copy) NSString *optime;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, assign) NSTimeInterval optimestamp;
@property (nonatomic, assign) NSTimeInterval ctimestamp;

@property (nonatomic, copy) NSString *pinpai;
@property (nonatomic, copy) NSString *pinpaiURL;

@property (nonatomic, copy) NSString *liveid;

@property (nonatomic, copy) NSString *downloadurl;

@property (nonatomic, strong) NSArray *products;

@property (nonatomic, assign) NSInteger num;        // 商品数量
@property (nonatomic, assign) NSInteger pnum;       // 实发数量
@property (nonatomic, assign) NSInteger cancelnum;  // 取消数量
@property (nonatomic, assign) NSInteger lacknum;    // 缺货数量

@property (nonatomic, assign) NSInteger dingdanjine;
@property (nonatomic, assign) NSInteger shangpinjine;
@property (nonatomic, assign) NSInteger zongjine;
@property (nonatomic, assign) NSInteger yunfeijine;
@property (nonatomic, assign) NSInteger dikoujine;
@property (nonatomic, assign) NSInteger tuikuanjine;

// 0: 初始态 1~3: 拣货中 4: 已发货
@property (nonatomic, assign) NSInteger statu;
// 已发货子状态  1: 部分发货 2: 完成发货 3: 整单缺货
@property (nonatomic, assign) NSInteger substatu;

@property (nonatomic, assign) BOOL isvirtual;   // 是否是虚拟商品

@property (nonatomic, assign) NSInteger akucunflag; // 自营标记，注 0是自营，1是第三方

@property (nonatomic, assign) NSInteger outaftersale; // > 0 超出售后时间
@property (nonatomic, assign) NSTimeInterval aftersaletimenum;
@property (nonatomic, copy) NSString *aftersaletime;

@property (nonatomic, copy) NSString *expectdelivertime; // 预计发货时间

@property (nonatomic, copy) NSString *barcodeconfig;

- (NSString *) subStatusText;
- (UIColor *) subTextColor;

- (NSInteger) daifahuoNum;

- (NSString *) dateString;

- (NSString *) displayWuliuInfo;

- (NSString *) getRangeBarcode:(NSString *)barcode;

@end
