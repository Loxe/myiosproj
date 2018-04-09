//
//  ResponseLiveList.m
//  akucun
//
//  Created by Jarry Zhu on 2017/12/28.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseLiveList.h"
#import "LiveManager.h"
#import "ProductsManager.h"

@implementation ResponseLiveList

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    // parse response data ...
    
    NSDictionary *forwardData = [ProductsManager instance].forwardData;
    NSMutableDictionary *newForward = [NSMutableDictionary dictionary];
    NSMutableArray *liveInfos = [NSMutableArray array];
    
    NSMutableString *liveIds = [NSMutableString string];
    NSInteger index = 0;
    for (LiveInfo *info in self.result) {
        [liveInfos addObject:info];
        // 设置默认转发品牌索引
        if (info.begintimestamp < [NSDate timeIntervalValue]
            && [ProductsManager instance].forwardPinpai < 0) {
            [ProductsManager instance].forwardPinpai = index;
        }
        //
        NSInteger count = [forwardData getIntegerValueForKey:info.liveid];
        [newForward setObject:@(count) forKey:info.liveid];
        
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
    [LiveManager instance].liveInfos = [liveInfos sortedArrayUsingComparator:cmptr];
    
    //
    [LiveManager instance].liveIds = liveIds;
    
    //
    [ProductsManager instance].forwardData = newForward;
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    LiveInfo *liveInfo = [LiveInfo yy_modelWithDictionary:dictionary];
    return liveInfo;
}

@end
