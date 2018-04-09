//
//  ResponseTradeList.m
//  akucun
//
//  Created by deepin do on 2018/1/9.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseTradeList.h"

@implementation ResponseTradeList

- (NSString *) resultKey
{
    return @"data";
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    TradeModel *trade = [TradeModel yy_modelWithDictionary:dictionary];
    return trade;
}

@end
