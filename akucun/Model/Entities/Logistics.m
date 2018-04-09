//
//  Logistics.m
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "Logistics.h"

@implementation Logistics

- (NSString *) displayMobile
{
    if (!self.lianxidianhua) {
        return @"";
    }
    NSInteger len = self.lianxidianhua.length;
    if (len < 11) {
        return self.lianxidianhua;
    }
    len = self.lianxidianhua.length-7;
    NSMutableString *text = [NSMutableString string];
    for (int i = 0; i < len; i ++) {
        [text appendString:@"*"];
    }
    return [self.lianxidianhua stringByReplacingCharactersInRange:NSMakeRange(3, len) withString:text];
}

@end
