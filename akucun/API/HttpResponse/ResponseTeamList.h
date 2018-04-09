//
//  ResponseTeamList.h
//  akucun
//
//  Created by deepin do on 2018/1/19.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseList.h"

@interface ResponseTeamList : HttpResponseList

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger activeCount;
@property (nonatomic, assign) NSInteger lostCount;

@end
