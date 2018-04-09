//
//  TradeModel.m
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "TradeModel.h"
#import "NSDate+akucun.h"

@implementation TradeModel

- (NSString *) displayTradeId
{
    return self.tradeId;
}

- (NSString *) displayStatusText
{
    if (self.tradeStatus == 0) {
        return @"交易成功";
    }
    else if (self.tradeStatus == 1) {
        return @"交易成功";
    }
    else if (self.tradeStatus == 2) {
        return @"交易失败";
    }
    else if (self.tradeStatus == 3) {
        return @"交易处理中";
    }
    
    return @"";
}

- (NSString *) displayTradeType {
    if (self.tradeType == 1) {
        return @"退款";
    } else {
        return @"订单支付";
    }
}

- (NSString *) displayAmount
{
    //默认钱是分为单位，先转成元
    CGFloat yuan = self.amount*0.01;
    if (self.tradeType == 1) {
        return FORMAT(@"+ %.2f",yuan);
    } else {
        return FORMAT(@"- %.2f",yuan);
    }
}

- (UIColor *) displayAmountColor
{
    if (self.tradeType == 1) {
        return [UIColor greenColor];
    }
    return COLOR_MAIN;
}

- (NSString *) displayDateString
{
    //默认时间戳是毫秒的，要除以1000
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:self.tradeTime*0.001];
    return [dateTime normalDateString];
}

- (NSString *) displayTradeInfo
{
    return self.tradeInfo;//如果需要根据逗号截取,再做处理
}

@end
