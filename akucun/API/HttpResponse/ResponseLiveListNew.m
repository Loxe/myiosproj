//
//  ResponseLiveListNew.m
//  akucun
//
//  Created by Jarry Z on 2018/3/15.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseLiveListNew.h"
#import "LiveManager.h"
#import "ProductsManager.h"
#import "UserManager.h"

@implementation ResponseLiveListNew

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    NSDictionary *dataDic = [jsonData objectForKey:@"data"];

    NSDictionary *forwardData = [ProductsManager instance].forwardData;
    NSMutableDictionary *newForward = [NSMutableDictionary dictionary];
    NSMutableString *liveIds = [NSMutableString string];
    NSInteger index = 0;

    NSInteger vipLevel = [UserManager instance].userInfo.viplevel;
    
    NSArray *liveArray = [dataDic objectForKey:@"direct_seeding"];
    if (self.modeltype == 0 || liveArray.count > 0) {
        NSMutableString *liveId1 = [NSMutableString string];
        NSMutableArray *liveInfos = [NSMutableArray array];
        NSTimeInterval time = 0;
        for (NSDictionary *itemDic in liveArray) {
            LiveInfo *item = [LiveInfo yy_modelWithDictionary:itemDic];
            if (time < item.begintimestamp) {
                time = item.begintimestamp;
            }
            NSInteger levelFlag = [item levelFlag];
            if (levelFlag > 0 && vipLevel < levelFlag) {
                continue;
            }
            
            if (index == 0) {
                item.isTop = YES;
                item.memberLevels = 3;
            }
            if (item.isTop) {   // 置顶的
                [liveInfos insertObject:item atIndex:0];
            }
            else {
                [liveInfos addObject:item];
            }
            
            //
            NSInteger count = [forwardData getIntegerValueForKey:item.liveid];
            [newForward setObject:@(count) forKey:item.liveid];
            
            if (liveId1.length > 0) {
                [liveId1 appendString:@","];
            }
            [liveId1 appendString:item.liveid];
            index ++;
        }
        [LiveManager instance].liveInfos = liveInfos;
        [LiveManager instance].liveId1 = liveId1;
        if (liveId1.length > 0) {
            [liveIds appendString:liveId1];
            [liveIds appendString:@","];
        }
        // 记录最新直播活动时间
        [[UserManager instance] updateLiveTime:time with:0];
    }
    else {
        [liveIds appendString:[LiveManager instance].liveId1];
        if (liveIds.length > 0) {
            [liveIds appendString:@","];
        }
    }
    
    NSArray *performanceArray = [dataDic objectForKey:@"performance"];
    if (self.modeltype == 3 || performanceArray.count > 0) {
        NSMutableString *liveId2 = [NSMutableString string];
        NSMutableArray *dxLives = [NSMutableArray array];
        NSTimeInterval time = 0;
        for (NSDictionary *itemDic in performanceArray) {
            LiveInfo *item = [LiveInfo yy_modelWithDictionary:itemDic];
            if (time < item.begintimestamp) {
                time = item.begintimestamp;
            }
            NSInteger levelFlag = [item levelFlag];
            if (levelFlag > 0 && vipLevel < levelFlag) {
                continue;
            }
            if (item.isTop) {   // 置顶的
                [dxLives insertObject:item atIndex:0];
            }
            else {
                [dxLives addObject:item];
            }
            
            if (liveId2.length > 0) {
                [liveId2 appendString:@","];
            }
            [liveId2 appendString:item.liveid];
            
            index ++;
        }
        [LiveManager instance].dxLives = dxLives;
        [LiveManager instance].liveId2 = liveId2;
        if (liveId2.length > 0) {
            [liveIds appendString:liveId2];
            [liveIds appendString:@","];
        }
        // 记录最新专场活动时间
        [[UserManager instance] updateLiveTime:time with:1];
    }
    else {
        [liveIds appendString:[LiveManager instance].liveId2];
        if (liveIds.length > 0) {
            [liveIds appendString:@","];
        }
    }

    NSArray *explosionArray = [dataDic objectForKey:@"explosion"];
    if (self.modeltype == 1 || explosionArray.count > 0) {
        NSMutableString *liveId3 = [NSMutableString string];
        NSMutableArray *explosionLives = [NSMutableArray array];
        NSTimeInterval time = 0;
        for (NSDictionary *itemDic in explosionArray) {
            LiveInfo *item = [LiveInfo yy_modelWithDictionary:itemDic];
            if (time < item.begintimestamp) {
                time = item.begintimestamp;
            }
            NSInteger levelFlag = [item levelFlag];
            if (levelFlag > 0 && vipLevel < levelFlag) {
                continue;
            }
            if (item.isTop) {   // 置顶的
                [explosionLives insertObject:item atIndex:0];
            }
            else {
                [explosionLives addObject:item];
            }
            
            if (liveId3.length > 0) {
                [liveId3 appendString:@","];
            }
            [liveId3 appendString:item.liveid];
            
            index ++;
        }
        [LiveManager instance].explosionLives = explosionLives;
        [LiveManager instance].liveId3 = liveId3;
        if (liveId3.length > 0) {
            [liveIds appendString:liveId3];
        }
        // 记录最新爆款活动时间
        [[UserManager instance] updateLiveTime:time with:2];
    }
    else {
        [liveIds appendString:[LiveManager instance].liveId3];
    }
    
    [LiveManager instance].liveIds = liveIds;
    [ProductsManager instance].forwardData = newForward;
    
//    ERRORLOG(@"=====> \n%@\n=====>%@", liveIds, [LiveManager instance].overLiveIds);
    
    NSDictionary *titleDic = [jsonData objectForKey:@"title"];
    NSDictionary *corpDic = [titleDic objectForKey:@"performance"];
    if (corpDic) {
        CorpInfo *corpInfo = [CorpInfo yy_modelWithDictionary:corpDic];
        [LiveManager instance].dxCorpInfo = corpInfo;
    }
    
    //
    NSMutableArray *liveDatas = [NSMutableArray array];
    [liveDatas addObjectsFromArray:[LiveManager instance].liveInfos];
    [liveDatas addObjectsFromArray:[LiveManager instance].dxLives];
    [liveDatas addObjectsFromArray:[LiveManager instance].explosionLives];
    // 排序
    NSComparator cmptr = ^(id obj1, id obj2){
        LiveInfo *p1 = obj1;
        LiveInfo *p2 = obj2;
//        if (p1.) {    // 置顶的
//            return (NSComparisonResult)NSOrderedAscending;
//        }
        if (p1.begintimestamp < p2.begintimestamp) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (p1.begintimestamp > p2.begintimestamp) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    [LiveManager instance].liveDatas = [liveDatas sortedArrayUsingComparator:cmptr];
    
    // 设置默认转发品牌索引
    if (liveDatas.count > 0) {
        LiveInfo *first = [LiveManager instance].liveDatas[0];
        if (first.begintimestamp < [NSDate timeIntervalValue]
            && [ProductsManager instance].forwardPinpai < 0) {
            [ProductsManager instance].forwardPinpai = 0;
        }
    }
}

@end
