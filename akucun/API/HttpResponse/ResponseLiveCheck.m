//
//  ResponseLiveCheck.m
//  akucun
//
//  Created by Jarry Z on 2018/3/24.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseLiveCheck.h"

@implementation ResponseLiveCheck

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    NSInteger type3 = [jsonData getIntegerValueForKey:@"herald"];
    NSInteger type0 = [jsonData getIntegerValueForKey:@"directseeding"];
    NSInteger type1 = [jsonData getIntegerValueForKey:@"performance"];
    NSInteger type2 = [jsonData getIntegerValueForKey:@"explosion"];

    NSDictionary *flagDic = @{ @"0" : @(type0>0),
                               @"1" : @(type1>0),
                               @"2" : @(type2>0),
                               @"3" : @(type3>0)
                               };
    self.flagData = flagDic;
    
    self.isLiveUpdated = ((type0+type1+type2) > 0);
}

@end
