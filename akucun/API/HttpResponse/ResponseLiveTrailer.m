//
//  ResponseLiveTrailer.m
//  akucun
//
//  Created by Jarry on 2017/3/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ResponseLiveTrailer.h"
#import "LiveManager.h"
#import "UserManager.h"

@implementation ResponseLiveTrailer

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    // parse response data ...
    
    NSInteger vipLevel = [UserManager instance].userInfo.viplevel;

    NSMutableArray *listData = [NSMutableArray array];
    NSTimeInterval time = 0;
    for (Trailer *item in self.result) {
        if (time < item.begintimestamp) {
            time = item.begintimestamp;
        }
        NSInteger levelFlag = [item levelFlag];
        if (levelFlag > 0 && vipLevel < levelFlag) {
            continue;
        }
        [listData addObject:item];
    }
    // 记录最新预告活动时间
    [[UserManager instance] updateLiveTime:time with:3];

    //
    NSComparator cmptr = ^(id obj1, id obj2){
        Trailer *p1 = obj1;
        Trailer *p2 = obj2;
        if (p1.begintimestamp > p2.begintimestamp) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (p1.begintimestamp < p2.begintimestamp) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    [LiveManager instance].trailerInfos = [listData sortedArrayUsingComparator:cmptr];
//    [LiveManager instance].trailerInfos = self.result;
}

- (id) parseItemFrom:(NSDictionary *)dictionary
{
    Trailer *trailer = [Trailer yy_modelWithDictionary:dictionary];
    return trailer;
}

@end
