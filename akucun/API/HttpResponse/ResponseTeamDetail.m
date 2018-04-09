//
//  ResponseTeamDetail.m
//  akucun
//
//  Created by deepin do on 2018/1/19.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseTeamDetail.h"


@implementation ResponseTeamDetail

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    NSString *level        = jsonData[@"level"];
    NSString *monthsTotal  = jsonData[@"monthsTotal"];
    NSString *todoReward   = jsonData[@"todoReward"];
    NSString *rewardTotal  = jsonData[@"rewardTotal"];
    
    NSDictionary *levelDict = jsonData[@"amountArea"];
    NSString *one   = levelDict[@"1"];
    NSString *two   = levelDict[@"2"];
    NSString *three = levelDict[@"3"];
    NSString *four  = levelDict[@"4"];
    NSString *five  = levelDict[@"5"];
    NSString *six   = levelDict[@"6"];
    
    self.level       = [level integerValue];
    self.monthsTotal = [monthsTotal integerValue];
    self.todoReward  = [todoReward integerValue];
    self.rewardTotal = [rewardTotal integerValue];
    
    self.levelOne    = [one integerValue];
    self.levelTwo    = [two integerValue];
    self.levelThree  = [three integerValue];
    self.levelFour   = [four integerValue];
    self.levelFive   = [five integerValue];
    self.levelSix    = [six integerValue];
    
    NSDictionary *ruleData = [jsonData objectForKey:@"rule"];
    if (ruleData) {
        self.videoUrl = [ruleData getStringForKey:@"videoUrl"];
        self.ruleUrl = [ruleData getStringForKey:@"ruleUrl"];
    }
}



@end
