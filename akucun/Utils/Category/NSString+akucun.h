//
//  NSString+akucun.h
//  akucun
//
//  Created by Jarry on 2017/6/16.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (akucun)

+ (NSString *) priceString:(double)price;

+ (NSString *) amountCommaString:(double)amount;
+ (NSString *) amountCommaFullString:(double)amount;

+ (BOOL) isEmpty:(NSString *)str;

/**
 *  手机号格式有效性校验
 *  @return YES/NO
 */
- (BOOL) checkValidateMobile;

- (BOOL) isChinaMobile;
- (BOOL) isChinaUnicom;
- (BOOL) isChinaTelecom;

- (NSString *) displayMobile;

- (CGSize) sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font;

- (NSString *) filterSpace;

- (NSString *) filterSpaceAndNewline;

/** 三位数加一个逗号小数点后的忽略 */
- (NSString *) strmethodComma:(NSString*)str;


@end
