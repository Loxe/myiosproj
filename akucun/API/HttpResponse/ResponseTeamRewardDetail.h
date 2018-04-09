//
//  ResponseTeamRewardDetail.h
//  akucun
//
//  Created by deepin do on 2018/1/20.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseBase.h"

@interface ResponseTeamRewardDetail : HttpResponseBase

@property(nonatomic, assign) NSInteger todoReward;
@property(nonatomic, assign) NSInteger rewardTotal;

@property(nonatomic, assign) NSInteger mySale;
@property(nonatomic, assign) NSInteger oneLevelAmount;
@property(nonatomic, assign) NSInteger twoLevelAmount;

@property(nonatomic, assign) NSInteger oneLevelReward;
@property(nonatomic, assign) NSInteger twoLevelReward;

@property(nonatomic, strong) NSString *oneLevelRewardRate;
@property(nonatomic, strong) NSString *twoLevelRewardRate;

@property(nonatomic, assign) NSInteger totalReward;

@end
