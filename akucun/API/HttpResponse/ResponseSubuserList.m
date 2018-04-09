//
//  ResponseSubuserList.m
//  akucun
//
//  Created by Jarry Zhu on 2018/1/3.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseSubuserList.h"

@implementation ResponseSubuserList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];

    NSMutableArray *array = [NSMutableArray array];
    for (SubUser *item in self.result) {
        if ([item isPrimaryAccount]) {
            self.phoneAccount = item;
        }
        else if (item.istabaccount) {
            [array insertObject:item atIndex:0];
        }
        else {
            [array addObject:item];
        }
    }
    self.result = array;
    [UserManager instance].userInfo.subUserinfos = self.result;
}

- (NSString *) resultKey
{
    return @"subuserinfos";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    SubUser *user = [SubUser yy_modelWithDictionary:dictionary];
    return user;
}

@end
