//
//  RequestDirectBuy.m
//  akucun
//
//  Created by Jarry Zhu on 2017/11/5.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "RequestDirectBuy.h"

@implementation RequestDirectBuy

- (NSString *) uriPath
{
    return @"cento.do";   //API_URI_ORDER;
}

- (NSString *) actionId
{
    return ACTION_ORDER_BUY;
}

- (void) initJsonBody
{
    //
    [self.jsonBody setValue:self.liveId forKey:@"liveid"];
    [self.jsonBody setValue:self.productId forKey:@"productid"];
    [self.jsonBody setValue:self.skuId forKey:@"skuid"];
    [self.jsonBody setValue:self.addrId forKey:@"addrid"];
    [self.jsonBody setValue:self.remark forKey:@"remark"];
}

@end
