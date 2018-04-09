//
//  ResponseVIPPurchase.m
//  akucun
//
//  Created by Jarry on 2017/9/3.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseVIPPurchase.h"

@implementation ResponseVIPPurchase

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    self.payInfo = [jsonData objectForKey:@"payinfo"];
}

@end
