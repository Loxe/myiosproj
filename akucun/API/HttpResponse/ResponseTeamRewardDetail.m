//
//  ResponseTeamRewardDetail.m
//  akucun
//
//  Created by deepin do on 2018/1/20.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseTeamRewardDetail.h"

@implementation ResponseTeamRewardDetail

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    NSString *todoReward      = jsonData[@"todoReward"];
    NSString *rewardTotal     = jsonData[@"rewardTotal"];
    NSDictionary *amountsDict = jsonData[@"amounts"];

    self.todoReward  = [todoReward integerValue];
    self.rewardTotal = [rewardTotal integerValue];

    self.mySale         = [amountsDict[@"mySale"] integerValue];
    self.oneLevelAmount = [amountsDict[@"oneLevelAmount"] integerValue];
    self.twoLevelAmount = [amountsDict[@"twoLevelAmount"] integerValue];
    self.oneLevelReward = [amountsDict[@"oneLevelReward"] integerValue];
    self.twoLevelReward = [amountsDict[@"twoLevelReward"] integerValue];
    self.totalReward    = [amountsDict[@"totalReward"] integerValue];
    
    self.oneLevelRewardRate = amountsDict[@"oneLevelRewardRate"];
    self.twoLevelRewardRate = amountsDict[@"twoLevelRewardRate"];
}

@end
