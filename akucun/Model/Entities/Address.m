//
//  Address.m
//  akucun
//
//  Created by Jarry on 2017/4/4.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "Address.h"

@implementation Address

+ (NSDictionary *) modelCustomPropertyMapper
{
    return @{ @"name": @"shoujianren",
              @"mobile": @"dianhua",
              @"province": @"sheng",
              @"city": @"shi",
              @"area": @"qu",
              @"address": @"detailaddr"
              };
}

- (NSString *) displayMobile
{
    if (!self.mobile) {
        return @"";
    }
    NSInteger len = self.mobile.length;
    if (len < 11) {
        return self.mobile;
    }
    len = self.mobile.length-7;
    NSMutableString *text = [NSMutableString string];
    for (int i = 0; i < len; i ++) {
        [text appendString:@"*"];
    }
    return [self.mobile stringByReplacingCharactersInRange:NSMakeRange(3, len) withString:text];
}

- (NSString *) displayAddress
{
    if ([self.province isEqualToString:self.city]) {
        return FORMAT(@"%@ %@ %@", self.province, self.area, self.address);
    }
    return FORMAT(@"%@ %@ %@ %@", self.province, self.city, self.area, self.address);
}

@end
