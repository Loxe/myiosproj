//
//  ResponseAftersaleInfo.m
//  akucun
//
//  Created by Jarry on 2017/9/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseAftersaleInfo.h"

@implementation ResponseAftersaleInfo

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    self.asaleService = [ASaleService yy_modelWithDictionary:[jsonData objectForKey:@"product"]];
}

@end
