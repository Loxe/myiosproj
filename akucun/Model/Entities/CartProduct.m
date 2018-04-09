//
//  CartProduct.m
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "CartProduct.h"

@implementation CartProduct

+ (NSDictionary *) modelCustomPropertyMapper
{
    return @{ @"productid" : @[@"productid", @"id"],
              @"status" : @[@"status", @"shangpinzhuangtai"]
            };
}

+ (NSDictionary *) modelContainerPropertyGenericClass
{
    return @{@"sku" : [ProductSKU class]
              };
}

- (NSString *) productDesc
{
    NSMutableString *desc = [NSMutableString string];
    NSArray *array = [self.desc componentsSeparatedByString:@"\n"];
    for (NSString *text in array) {
        if (![text hasPrefix:@"尺码 "]) {
            [desc appendString:text];
            [desc appendString:@"\n"];
        }
    }
    return desc;
//    return FORMAT(@"%@、%@\n款式 %@\n款号 %@", self.xuhaostr, self.name, @"", self.kuanhao);
}

- (NSString *) imageUrl
{
    if (!self.tupianURL || self.tupianURL.length == 0) {
        return nil;
    }
    NSArray *array = [self.tupianURL componentsSeparatedByString:@","];
    NSString *url = array[0];
    return [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSArray *) imagesUrl
{
    if (!self.tupianURL || self.tupianURL.length == 0) {
        return nil;
    }
    NSString *urls = [self.tupianURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [urls componentsSeparatedByString:@","];
}

- (NSString *) statusText
{
    switch (self.status) {
        case ProductStatusInit:
            return @"未支付";
        case ProductStatusWeifahuo:
            return @"已支付";
        case ProductStatusYifahuo:
            return @"已发货";
        case ProductStatusFahuo:
            return @"拣货中";
        case ProductStatusCancel:
            return @"已取消";
        case ProductStatusQuehuo:
            return @"平台缺货 退款中";
        case ProductStatusTuihuo:
            return @"退货 已退款";
        case ProductStatusPending:
            return @"退货 退款中";
        case ProductStatusTuikuan:
            return @"用户取消 退款中";
        case ProductStatusTuikuanDone:
            return @"用户取消 已退款";
        case ProductStatusQuehuoDone:
            return @"平台缺货 已退款";
        case ProductASaleSubmit:
            return @"售后 已提交";
        case ProductASaleRejected:
            return @"售后 审核不通过";
        case ProductASalePending:
            return @"售后 处理中";
        case ProductASaleLoufaTuikuan:
            return @"售后 漏发已退款";
        case ProductASaleTuihuoTuikuan:
            return @"售后 退货已退款";
        case ProductASaleTuihuoPending:
            return @"售后 退货处理中";
    }
    return @"";
}

- (BOOL) quehuo
{
    return (self.shuliang <= 0);
}

- (NSString *) jiesuanPrice
{
    return FORMAT(@"结算价：¥ %.2f", self.jiesuanjia/100.0f);
}

@end
