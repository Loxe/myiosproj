//
//  OrderModel.m
//  akucun
//
//  Created by Jarry on 2017/4/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "OrderModel.h"
#import "NSDate+akucun.h"

@implementation OrderModel

- (BOOL) modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    NSTimeInterval delta = self.overtimeshuzi - [NSDate timeIntervalValue];
    if (delta <= 0 && self.status == 0) {
        self.status = 5;
    }
    return YES;
}

- (NSString *) displayOrderId
{
    return [self.orderid substringFromIndex:12];
}

- (NSString *) statusText
{
    if (self.status == 0) {
        return @"待支付";
    }
    else if (self.status == 1) {
        return @"已支付";  //@"待发货";
    }
    else if (self.status == 2) {
        return @"已发货";
    }
    else if (self.status == 3) {
        return @"订单处理中"; // 第三方待发货，不能换尺码，只能退款退货
    }
    else if (self.status == 4) {
        return @"未支付 用户取消";
    }
    else if (self.status == 5) {
        return @"未支付 超时取消";
    }
    else if (self.status == 6) {
        return @"已支付 用户取消";
    }
    return @"";
}

- (UIColor *) statusColor
{
    if (self.status == 2) {
        return COLOR_TEXT_DARK;
    }
    return RED_COLOR;
}

- (NSString *) totalAmount
{
    return FORMAT(@"¥ %.2f", self.zongjine/100.0f);
}

- (NSString *) dateString
{
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:self.dingdanshijianshuzi];
    return [dateTime weekDateString];
}

- (NSString *) dingdanshijian
{
    if (!_dingdanshijian) {
        return @" -- ";
    }
    return _dingdanshijian;
}

@end
