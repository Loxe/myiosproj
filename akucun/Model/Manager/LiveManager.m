//
//  LiveManager.m
//  akucun
//
//  Created by Jarry on 2017/4/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LiveManager.h"
#import "ProductsManager.h"
#import "RequestLiveUpdate.h"

@implementation LiveManager
/*
+ (BOOL) liveChanged:(NSString *)pinpaiIds
{
    NSString *oldPinpaiIds = [LiveManager instance].livePinpaiIds;
    if (oldPinpaiIds && ![oldPinpaiIds isEqualToString:pinpaiIds]) {
        return YES;
    }
    return NO;
}*/

+ (NSInteger) liveState
{
    return [LiveManager instance].state;
}

+ (NSInteger) periodTime
{
    return [LiveManager instance].periodTime;
    /*
    NSInteger state = [LiveManager liveState];
    LiveControl *control = nil;
    
    if (state == 1) {
        control = [LiveManager instance].liveControl;
    }
    else {
        control = [LiveManager instance].liveOver;
    }
    
    if (!control) {
        return 30;
    }
    
    if (control.flag == 1 && control.period > 0) {
        return control.period;
    }
    int period = (int) ((arc4random() % (control.max - control.min + 1)) + control.min);
    NSLog(@"Live Period : %d", period);
    return period;
     */
}

+ (LiveInfo *) getLiveInfo:(NSString *)liveId
{
    LiveInfo *liveInfo = nil;
    NSArray *liveInfos = [LiveManager instance].liveDatas;
    for (LiveInfo *item in liveInfos) {
        if ([item.liveid isEqualToString:liveId]) {
            liveInfo = item;
            return liveInfo;
        }
    }
    /*
    for (LiveInfo *item in liveInfos) {
        if ([item.liveid isEqualToString:liveId]) {
            liveInfo = item;
            return liveInfo;
        }
    }
    
    NSArray *dxLives = [LiveManager instance].dxLives;
    for (LiveInfo *item in dxLives) {
        if ([item.liveid isEqualToString:liveId]) {
            liveInfo = item;
            return liveInfo;
        }
    }
    
    NSArray *explosionLives = [LiveManager instance].explosionLives;
    for (LiveInfo *item in explosionLives) {
        if ([item.liveid isEqualToString:liveId]) {
            liveInfo = item;
            return liveInfo;
        }
    }*/
//    [LiveManager instance].liveInfo = liveInfo;
    return liveInfo;
}

+ (void) updateLiveInfo:(LiveInfo *)liveInfo
{
    LiveInfo *live = [self getLiveInfo:liveInfo.liveid];
    live = liveInfo;
}

+ (LiveInfo *) liveInfoAtIndex:(NSInteger)index
{
    NSArray *liveInfos = [LiveManager instance].liveDatas;
    if (index < 0 || index >= liveInfos.count) {
        return nil;
    }
    return liveInfos[index];
    /*
    NSArray *liveInfos = [LiveManager instance].liveInfos;
    NSInteger liveCount = liveInfos.count;
    if (index < liveCount) {
        return liveInfos[index];
    }
    
    NSArray *dxLives = [LiveManager instance].dxLives;
    NSInteger dxCount = dxLives.count;
    if (index < liveCount+dxCount) {
        return dxLives[index-liveCount];
    }
    
    NSArray *explosionLives = [LiveManager instance].explosionLives;
    return explosionLives[index-liveCount-dxCount];*/
}

+ (NSInteger) liveIndexByLiveId:(NSString *)liveId
{
    NSArray *liveInfos = [LiveManager instance].liveDatas;
    NSInteger index = 0;
    for (LiveInfo *item in liveInfos) {
        if ([item.liveid isEqualToString:liveId]) {
            return index;
        }
        index ++;
    }
    /*
    NSArray *dxLives = [LiveManager instance].dxLives;
    for (LiveInfo *item in dxLives) {
        if ([item.liveid isEqualToString:liveId]) {
            return index;
        }
        index ++;
    }
    //
    NSArray *explosionLives = [LiveManager instance].explosionLives;
    for (LiveInfo *item in explosionLives) {
        if ([item.liveid isEqualToString:liveId]) {
            return index;
        }
        index ++;
    }*/
    return 0;
}

+ (NSArray *) getLivePinpais
{
    NSMutableArray *pinpais = [NSMutableArray array];
    NSArray *liveInfos = [LiveManager instance].liveDatas;
    for (LiveInfo *item in liveInfos) {
        [pinpais addObject:item.pinpaiming];
    }
    /*
    NSArray *dxLives = [LiveManager instance].dxLives;
    for (LiveInfo *item in dxLives) {
        [pinpais addObject:item.pinpaiming];
    }
    //
    NSArray *explosionLives = [LiveManager instance].explosionLives;
    for (LiveInfo *item in explosionLives) {
        [pinpais addObject:item.pinpaiming];
    }*/
    return pinpais;
}

+ (NSArray *) getLiveLogos
{
    NSMutableArray *logoUrls = [NSMutableArray array];
    NSArray *liveInfos = [LiveManager instance].liveDatas;
    for (LiveInfo *item in liveInfos) {
        [logoUrls addObject:item.pinpaiurl];
    }
    /*
    NSArray *dxLives = [LiveManager instance].dxLives;
    for (LiveInfo *item in dxLives) {
        [logoUrls addObject:item.pinpaiurl];
    }
    //
    NSArray *explosionLives = [LiveManager instance].explosionLives;
    for (LiveInfo *item in explosionLives) {
        [logoUrls addObject:item.pinpaiurl];
    }*/
    return logoUrls;
}

+ (LiveManager *) instance
{
    static dispatch_once_t  onceToken;
    static LiveManager * instance;
    dispatch_once(&onceToken, ^{
        instance = [[LiveManager alloc] init];
    });
    return instance;
}

#pragma mark -

- (id) init
{
    self = [super init];
    if (self) {
        //
        NSNumber *updateTime = [USER_DEFAULT objectForKey:UDK_STATE_UPDATE];
        if (updateTime) {
            self.updateTime = [updateTime doubleValue];
        }
        
        _liveId1 = @"";
        _liveId2 = @"";
        _liveId3 = @"";
        
        _liveIds = [USER_DEFAULT objectForKey:UDK_LIVE_LIVEIDS];
        _overLiveIds = [USER_DEFAULT objectForKey:UDK_OVER_LIVEIDS];
        
        INFOLOG(@"live : %@\n over : %@", _liveIds, _overLiveIds);
        
        self.periodTime = -1;
    }
    return self;
}

- (void) setUpdateTime:(NSTimeInterval)updateTime
{
    _updateTime = updateTime;
    
    [USER_DEFAULT setObject:@(updateTime) forKey:UDK_STATE_UPDATE];
    [USER_DEFAULT synchronize];
}

- (void) setLiveIds:(NSString *)liveIds
{
    if ([_liveIds isEqualToString:liveIds]) {
        return;
    }
    
    //
    if (_liveIds) {
        NSMutableString *overLiveIds = [NSMutableString string];
        NSArray *lives = [_liveIds componentsSeparatedByString:@","];
        NSInteger index = 0;
        for (NSString *liveId in lives) {
            NSRange range = [liveIds rangeOfString:liveId];
            if (range.length == 0) {
                if (index > 0) {
                    [overLiveIds appendString:@","];
                }
                [overLiveIds appendString:liveId];
                index ++;
            }
        }
        self.overLiveIds = overLiveIds;
    }
    
    _liveIds = liveIds;
    [USER_DEFAULT setObject:liveIds forKey:UDK_LIVE_LIVEIDS];
    [USER_DEFAULT synchronize];
}

- (void) setOverLiveIds:(NSString *)overLiveIds
{
    _overLiveIds = overLiveIds;
    
    if (overLiveIds) {
        [USER_DEFAULT setObject:overLiveIds forKey:UDK_OVER_LIVEIDS];
    }
    else {
        [USER_DEFAULT removeObjectForKey:UDK_OVER_LIVEIDS];
    }
    [USER_DEFAULT synchronize];
}

- (void) requestUpdateLive:(NSString *)liveId
{
    RequestLiveUpdate *request = [RequestLiveUpdate new];
    request.liveid = liveId;
    
    [SCHttpServiceFace serviceWithRequest:request onSuccess:^(id content) {
        
    } onFailed:nil];
}

@end
