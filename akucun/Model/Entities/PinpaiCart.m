//
//  PinpaiCart.m
//  akucun
//
//  Created by Jarry on 2017/5/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "PinpaiCart.h"

@implementation PinpaiCart

+ (NSDictionary *) modelContainerPropertyGenericClass
{
    return @{ @"cartproducts" : [CartProduct class]
              };
}

@end
