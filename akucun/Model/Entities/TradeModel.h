//
//  TradeModel.h
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTModel.h"

@interface TradeModel : JTModel

@property (nonatomic, copy) NSString *tradeId;     //支付/退款流水号
@property (nonatomic, copy) NSString *tradeInfo;   //交易明细

@property (nonatomic, assign) NSTimeInterval tradeTime;   //支付/退款时间

@property (nonatomic, assign) NSInteger amount;      //支付/退款金额
@property (nonatomic, assign) NSInteger tradeType;   //0:支付/1:退款
@property (nonatomic, assign) NSInteger tradeStatus; //订单状态 1.成功 2.失败 3.处理中 目前默认为0

- (NSString *) displayTradeId;

- (NSString *) displayStatusText;

- (NSString *) displayDateString;

- (NSString *) displayTradeType;

- (NSString *) displayAmount;

- (UIColor *)  displayAmountColor;

- (NSString *) displayTradeInfo;

@end
