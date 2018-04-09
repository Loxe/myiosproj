//
//  Member.m
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "Member.h"

@implementation Member

+ (NSDictionary *) modelCustomPropertyMapper
{
    return @{ @"avatar": @[@"avatar", @"avator"],
              @"username": @[@"username", @"nick"],
              @"monthsTotal": @[@"monthsTotal",@"membrMonthSale"]
            };
}

@end
