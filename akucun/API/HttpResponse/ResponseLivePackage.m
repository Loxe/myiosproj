//
//  ResponseLivePackage.m
//  akucun
//
//  Created by Jarry Z on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseLivePackage.h"
#import "ProductsManager.h"

@implementation ResponseLivePackage

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    // parse response data ...
    
    NSMutableArray *liveInfos = [NSMutableArray array];
    NSMutableString *liveIds = [NSMutableString string];
    NSInteger index = 0;
    for (LiveInfo *info in self.result) {
        [liveInfos addObject:info];

        if (index > 0) {
            [liveIds appendString:@","];
        }
        [liveIds appendString:info.liveid];
        
        index ++;
    }
    //
    NSComparator cmptr = ^(id obj1, id obj2){
        LiveInfo *p1 = obj1;
        LiveInfo *p2 = obj2;
        if (p1.begintimestamp < p2.begintimestamp) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (p1.begintimestamp > p2.begintimestamp) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    [LiveManager instance].livePackages = [liveInfos sortedArrayUsingComparator:cmptr];
    
    //
//    [LiveManager instance].liveIds = liveIds;
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    LiveInfo *liveInfo = [LiveInfo yy_modelWithDictionary:dictionary];
    return liveInfo;
}

@end
