//
//  ASaleService.m
//  akucun
//
//  Created by Jarry on 2017/9/12.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ASaleService.h"

@implementation ASaleService

+ (NSDictionary *) modelContainerPropertyGenericClass
{
    return @{ @"sku" : [ProductSKU class] };
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

- (NSString *) jiesuanPrice
{
    return FORMAT(@"结算价：¥ %.2f", self.jiesuanjia/100.0f);
}

- (NSString *) pingzhengUrl
{
    if (!self.pingzheng || self.pingzheng.length == 0) {
        return nil;
    }
    NSArray *array = [self.pingzheng componentsSeparatedByString:@","];
    NSString *url = array[0];
    return [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *) serviceTypeText
{
    switch (self.servicetype) {
        case 1:
            return @"漏发补发";
        case 2:
            return @"漏发退款";
        case 3:
            return @"退货并补发";
        case 4:
            return @"退货退款";
            
        default:
            break;
    }
    return @"";
}

- (NSString *) statusText
{
    switch (self.chulizhuangtai) {
        case ASaleStatusSubmit:
            return @"申请已提交";
        case ASaleStatusRejected:
            return @"审核未通过";
        case ASaleStatusPending:
            return @"售后处理中";
        case ASaleStatusLoufaBufa:
            return @"漏发已补发";
        case ASaleStatusLoufaTuikuan:
            return @"漏发已退款";
        case ASaleStatusTuihuoBufa:
            return @"退货已补发";
        case ASaleStatusTuihuoTuikuan:
            return @"退货已退款";
        case ASaleStatusTuihuoPending:
            return @"退货处理中";
        case ASaleStatusCanceled:
            return @"已撤销";
    }
    return @"";
}

- (UIColor *) statusColor
{
    switch (self.chulizhuangtai) {
        case ASaleStatusLoufaBufa:
        case ASaleStatusLoufaTuikuan:
        case ASaleStatusTuihuoBufa:
        case ASaleStatusTuihuoTuikuan:
            return COLOR_APP_GREEN;
        case ASaleStatusCanceled:
            return COLOR_TEXT_NORMAL;
    }
    return RED_COLOR;
}

@end
