//
//  LiveInfo.h
//  akucun
//
//  Created by Jarry on 2017/4/24.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "JTModel.h"

@interface LiveInfo : JTModel

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *pinpaiid;
@property (nonatomic, copy) NSString *pinpaiming;
@property (nonatomic, copy) NSString *pinpaiurl;
@property (nonatomic, copy) NSString *liveid;

@property (nonatomic, copy) NSString *today;

@property (nonatomic, assign) NSTimeInterval begintimestamp;
@property (nonatomic, assign) NSTimeInterval endtimestamp;

@property (nonatomic, copy) NSString *yugaoneirong;
@property (nonatomic, copy) NSString *yugaotupian;

@property (nonatomic, assign) NSInteger buymodel;
@property (nonatomic, strong) NSArray *comments;

@property (nonatomic, copy) NSString *checksheeturl;  // 对账单下载地址

@property (nonatomic, assign) NSInteger memberLevels; // 会员专享标识
@property (nonatomic, assign) BOOL isTop;           // 活动置顶标识

// 订单
@property (nonatomic, assign) NSInteger adcount;    // 活动下发货单数量
@property (nonatomic, assign) NSInteger prosum;     // 活动下订单商品总数量
@property (nonatomic, assign) NSInteger scancount;  // 已扫描分拣的商品数量
@property (nonatomic, assign) NSInteger amount;     // 活动下订单商品总金额


- (NSArray *) imagesUrl;

// 活动开始两小时内
- (BOOL) isNewLive;

- (BOOL) isTodayLive;

- (NSInteger) levelFlag;

@end
