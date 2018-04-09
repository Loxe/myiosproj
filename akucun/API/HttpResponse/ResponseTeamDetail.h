//
//  ResponseTeamDetail.h
//  akucun
//
//  Created by deepin do on 2018/1/19.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseBase.h"

@interface ResponseTeamDetail : HttpResponseBase

@property(nonatomic, assign) NSInteger level;

@property(nonatomic, assign) NSInteger monthsTotal;

@property(nonatomic, assign) NSInteger todoReward;

@property(nonatomic, assign) NSInteger rewardTotal;

@property(nonatomic, assign) NSInteger levelOne;

@property(nonatomic, assign) NSInteger levelTwo;

@property(nonatomic, assign) NSInteger levelThree;

@property(nonatomic, assign) NSInteger levelFour;

@property(nonatomic, assign) NSInteger levelFive;

@property(nonatomic, assign) NSInteger levelSix;

@property(nonatomic, copy) NSString *videoUrl;
@property(nonatomic, copy) NSString *ruleUrl;

@end
