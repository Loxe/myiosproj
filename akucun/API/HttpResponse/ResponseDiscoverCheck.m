//
//  ResponseDiscoverCheck.m
//  akucun
//
//  Created by Jarry Z on 2018/3/21.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseDiscoverCheck.h"

@implementation ResponseDiscoverCheck

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];

    NSInteger status = [jsonData getIntegerValueForKey:@"status"];
    if (status > 0) {
        self.isUpdated = YES;
    }
    
    NSDictionary *checkData = [jsonData objectForKey:@"check"];
    if (checkData) {
        NSInteger type1 = [checkData getIntegerValueForKey:@"typeone"];
        NSInteger type2 = [checkData getIntegerValueForKey:@"typetwo"];
        NSInteger type3 = [checkData getIntegerValueForKey:@"typethree"];
        NSInteger type4 = [checkData getIntegerValueForKey:@"typefour"];
        NSInteger type5 = [checkData getIntegerValueForKey:@"typefive"];

        NSDictionary *flagDic = @{ @"1" : @(type1>0),
                                   @"2" : @(type2>0),
                                   @"3" : @(type3>0),
                                   @"4" : @(type4>0),
                                   @"5" : @(type5>0)
                                   };
        self.flagData = flagDic;
        
        NSInteger total = type1+type2+type3+type4+type5;
        self.isUpdated = (total>0);
    }
}

@end
