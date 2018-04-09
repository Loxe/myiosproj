//
//  ResponseForwardList.m
//  akucun
//
//  Created by Jarry on 2017/4/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseForwardList.h"
#import "ProductsManager.h"
#import "UserManager.h"

@implementation ResponseForwardList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];

    self.products = [NSMutableArray array];
    
    for (NSString *productId in self.result) {
        
        ProductModel *product = [[ProductsManager instance] productById:productId];
        if (product) {
            [self.products addObject:product];
        }
    }
    
    //
    NSDictionary *userDic = [jsonData objectForKey:@"user"];
    if (userDic) {
        NSInteger forward = [userDic getIntegerValueForKey:@"forwardcount"];
        NSInteger keyongdikou = [userDic getIntegerValueForKey:@"keyongdikou"];
        NSInteger yiyongdikou = [userDic getIntegerValueForKey:@"yiyongdikou"];

        UserInfo *userInfo = [UserManager instance].userInfo;
        userInfo.forwardcount = forward;
        userInfo.keyongdikou = keyongdikou;
        userInfo.yiyongdikou = yiyongdikou;
    }
}

- (NSString *) resultKey
{
    return @"products";
}

- (NSMutableArray *) getResultFrom:(id)datas
{
    NSArray *array = [datas objectForKey:[self resultKey]];
    return [NSMutableArray arrayWithArray:array];
}


@end
