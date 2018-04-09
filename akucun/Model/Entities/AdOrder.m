//
//  AdOrder.m
//  akucun
//
//  Created by Jarry on 2017/6/25.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "AdOrder.h"
#import "CartProduct.h"
#import "NSDate+akucun.h"

@implementation AdOrder

+ (NSDictionary *) modelContainerPropertyGenericClass
{
    return @{ @"products" : [CartProduct class]
              };
}

- (BOOL) modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    NSArray *array = [self.expectdelivertime componentsSeparatedByString:@" "];
    self.expectdelivertime = array[0];
    self.pinpai = [self.pinpai stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return YES;
}

- (NSString *) subStatusText
{
    switch (self.substatu) {
        case 1:
            return @"已发货";
        case 2:
            return @"完成发货";
        case 3:
            return @"整单缺货";
    }
    return @"";
}

- (UIColor *) subTextColor
{
    if (self.substatu == 2) {
        return COLOR_TEXT_DARK;
    }
    return COLOR_MAIN;
}

- (NSInteger) daifahuoNum
{
    return (self.num - self.cancelnum - self.lacknum);
}

- (NSString *) dateString
{
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:self.optimestamp];
    return [dateTime weekDateString];
}

- (NSString *) displayWuliuInfo
{
    NSArray *wuliuhaoArray = [self.wuliuhao componentsSeparatedByString:@","];
    if (wuliuhaoArray.count <= 1) {
        return FORMAT(@"%@\n单号 ：%@", self.wuliugongsi, self.wuliuhao);
    }
    
    NSMutableString *danhaoStr = [NSMutableString string];
    [danhaoStr appendFormat:@"%@", self.wuliugongsi];
    NSInteger index = 0;
    for (NSString *wuliuhao in wuliuhaoArray) {
        if (wuliuhao.length == 0) {
            continue;
        }
        index ++;
        [danhaoStr appendFormat:@"\n单号 %ld ：%@", (long)index, wuliuhao];
    }
    return danhaoStr;
}

- (BOOL) hasBarcodeConfig
{
    if (!self.barcodeconfig) {
        return NO;
    }
    NSArray *array = [self.barcodeconfig componentsSeparatedByString:@","];
    if (array.count == 2) {
        return YES;
    }
    
    else if (array.count == 1) {
        return [self.barcodeconfig isPureInt];
    }
    return NO;
}

/**
 条码配置规则
 n : n >= 0时，取条码字符串 第n位开始的所有字符
     n < 0时，截掉后面n位
 n,len : len > 0时，取条码字符串 第n位开始的len位长度字符 [n,len]
         len < 0时，取条码字符串 第n位开始的截掉后len长度的字符 [n,length-n+len]
 */
- (NSRange) barcodeRange:(NSInteger)length
{
    NSArray *array = [self.barcodeconfig componentsSeparatedByString:@","];
    if (array.count == 1) {
        int n = [self.barcodeconfig intValue];
        if (length <= abs(n)) {
            return NSMakeRange(0, length);
        }
        if (n < 0) {
            return NSMakeRange(0, length+n);
        }
        return NSMakeRange(n, length-n);
    }
    
    NSString *locStr = [array[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *lenStr = [array[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger loc = [locStr integerValue];
    NSInteger len = [lenStr integerValue];
    if (len < 0) {
        if (length <= loc-len) {
            return NSMakeRange(0, length);
        }
        return NSMakeRange(loc, length-loc+len);
    }
    if (length < loc+len) {
        return NSMakeRange(0, length);
    }
    return NSMakeRange(loc, len);
}

- (NSString *) getRangeBarcode:(NSString *)barcode
{
    if ([self hasBarcodeConfig]) {
        NSRange range = [self barcodeRange:barcode.length];
        return [barcode substringWithRange:range];
    }
    return barcode;
}

@end
