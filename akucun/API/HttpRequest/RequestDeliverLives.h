//
//  RequestDeliverLives.h
//  akucun
//
//  Created by Jarry Z on 2018/4/11.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseDeliverLives.h"

/**
 获取 拣货中/已发货 的活动列表
 */
@interface RequestDeliverLives : HttpRequestBase

@property (nonatomic, assign) NSInteger pageno;
@property (nonatomic, assign) NSInteger pagesize;

@property (nonatomic, assign) NSInteger type;       // 1：拣货中 2：已发货

@property (nonatomic, copy) NSString *begintime;    // 筛选 开始日期 2018-04-10
@property (nonatomic, copy) NSString *endtime;      // 筛选 结束日期 2018-04-12

@end
