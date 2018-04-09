//
//  ResponseBuyRecharge.m
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseBuyRecharge.h"

@implementation ResponseBuyRecharge

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    self.payInfo = [jsonData objectForKey:@"payinfo"];
}

@end
