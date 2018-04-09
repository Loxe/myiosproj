//
//  LiveManager.h
//  akucun
//
//  Created by Jarry on 2017/4/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "LiveControl.h"
#import "LiveInfo.h"
#import "Trailer.h"
#import "Pinpai.h"
#import "CorpInfo.h"

#define UDK_STATE_UPDATE        @"UDK_STATE_UPDATE"   //
#define UDK_LIVE_LIVEIDS        @"UDK_LIVE_LIVEIDS"
#define UDK_OVER_LIVEIDS        @"UDK_OVER_LIVEIDS"


@interface LiveManager : NSObject

@property (nonatomic, assign) NSInteger periodTime;
@property (nonatomic, assign) NSInteger skuPeriod;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, strong) NSArray  *liveInfos;
@property (nonatomic, strong) NSArray  *dxLives;
@property (nonatomic, strong) NSArray  *explosionLives;
@property (nonatomic, strong) CorpInfo  *dxCorpInfo;

// 所有活动列表（按时间排序）
@property (nonatomic, strong) NSArray  *liveDatas;

@property (nonatomic, strong) NSArray  *livePackages;

@property (nonatomic, strong) NSArray  *trailerInfos;

@property (nonatomic, copy) NSString *notice;

@property (nonatomic, assign) NSTimeInterval updateTime;

@property (nonatomic, copy) NSString *liveId1,*liveId2,*liveId3;

@property (nonatomic, copy) NSString *liveIds;
@property (nonatomic, copy) NSString *overLiveIds;


+ (NSInteger) liveState;

+ (NSInteger) periodTime;

+ (LiveInfo *) getLiveInfo:(NSString *)liveId;

+ (LiveInfo *) liveInfoAtIndex:(NSInteger)index;

+ (NSInteger) liveIndexByLiveId:(NSString *)liveId;

+ (NSArray *) getLivePinpais;

+ (NSArray *) getLiveLogos;

+ (void) updateLiveInfo:(LiveInfo *)liveInfo;

//+ (Trailer *) getTrailerInfo:(NSString *)pinpai;

+ (LiveManager *) instance;

- (void) requestUpdateLive:(NSString *)liveId;

@end
