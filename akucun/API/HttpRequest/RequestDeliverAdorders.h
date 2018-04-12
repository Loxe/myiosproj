//
//  RequestDeliverAdorders.h
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseDeliverAdorders.h"

/**
 获取活动下的所有发货单信息
 */
@interface RequestDeliverAdorders : HttpRequestBase

@property (nonatomic, copy) NSString *liveid;
@property (nonatomic, assign) NSInteger type;   // 1:拣货中 2：已发货

@end
