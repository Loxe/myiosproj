//
//  NSString+akucun.m
//  akucun
//
//  Created by Jarry on 2017/6/16.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "NSString+akucun.h"

@implementation NSString (akucun)

+ (NSString *) priceString:(double)price
{
    return FORMAT(@"¥ %.2f", price/100.0f);
}

// 带两位小数
+ (NSString *) amountCommaFullString:(double)amount
{
    double value = amount / 100.0f;
    if (value < 10) {
        return FORMAT(@"¥ %.2f",value);
    }
    NSString *valueStr = FORMAT(@"%.2f",value);
    valueStr = [valueStr strmethodComma:valueStr]; // 添加逗号
    valueStr = FORMAT(@"¥ %@", valueStr);           // 添加RMB标识
    return valueStr;
}

+ (NSString *) amountCommaString:(double)amount
{
    double value = amount / 100.0f;
    if (value < 10) {
        return FORMAT(@"¥%.1f",value);
    }
    NSString *valueStr = FORMAT(@"%.0f",value);     // 去掉小数点
    valueStr = [valueStr strmethodComma:valueStr];  // 添加逗号
    valueStr = FORMAT(@"¥%@", valueStr);           // 添加RMB标识
    return valueStr;
}

+ (BOOL) isEmpty:(NSString *)str
{
    if (str == nil || str.length == 0) {
        return YES;
    }
    return NO;
}

// 手机格式检测
- (BOOL) checkValidateMobile
{
    if (self.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7,9], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 3, 5, 6, 7, 8], 18[0-9]
     * 199, 198, 166
     */
    NSString *MOBILERegex = @"^1(3[0-9]|4[579]|5[0-35-9]|66|7[0135678]|8[0-9]|9[89])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILERegex];
    return [regextestmobile evaluateWithObject:self];
}

- (BOOL) isChinaMobile
{
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    return [regextestcm evaluateWithObject:self];
}

- (BOOL) isChinaUnicom
{
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    return [regextestcm evaluateWithObject:self];
}

- (BOOL) isChinaTelecom
{
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    return [regextestcm evaluateWithObject:self];
}

- (NSString *) displayMobile
{
    NSInteger len = self.length;
    if (len < 11) {
        return self;
    }
    len = self.length-7;
    NSMutableString *text = [NSMutableString string];
    for (int i = 0; i < len; i ++) {
        [text appendString:@"*"];
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, len) withString:text];
}

- (CGSize) sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font
{
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dict = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

- (NSString *) filterSpace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *) filterSpaceAndNewline
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)strmethodComma:(NSString*)str
{
    NSString *intStr;
    NSString *floStr;
    
    if ([str containsString:@"."]) {
        NSRange range = [str rangeOfString:@"."];
        floStr = [str substringFromIndex:range.location];
        intStr = [str substringToIndex:range.location];
    } else {
        floStr = @"";
        intStr = str;
    }
    
    if (intStr.length <= 3) {
        return [intStr stringByAppendingString:floStr];
    } else {
        
        NSInteger length = intStr.length;
        NSInteger count = length/3;
        NSInteger y = length%3;
        
        NSString *tit = [intStr substringToIndex:y] ;
        NSMutableString *det = [[intStr substringFromIndex:y] mutableCopy];

        for (int i =0; i < count; i ++) {
            NSInteger index = i + i *3;
            [det insertString:@","atIndex:index];
        }
        
        if (y ==0) {
            det = [[det substringFromIndex:1]mutableCopy];
        }
        
        intStr = [tit stringByAppendingString:det];
        return [intStr stringByAppendingString:floStr];
    }
}


@end
