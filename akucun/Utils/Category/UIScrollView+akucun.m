//
//  UIScrollView+akucun.m
//  akucun
//
//  Created by Jarry Z on 2018/4/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "UIScrollView+akucun.h"

@implementation UIScrollView (akucun)

+ (void)load
{
    if (@available(iOS 11.0, *)){
        [[self appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

@end
