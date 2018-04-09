//
//  SubUser.m
//  akucun
//
//  Created by Jarry Zhu on 2018/1/3.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "SubUser.h"

@implementation SubUser

+ (NSDictionary *) modelCustomPropertyMapper
{
    return @{ @"subUserId": @[@"id", @"subUserId"],
              @"avatar": @[@"avatar", @"avator"]
              };
}

- (BOOL) isPrimaryAccount
{
    return [self.userid isEqualToString:self.subUserId];
}

@end
