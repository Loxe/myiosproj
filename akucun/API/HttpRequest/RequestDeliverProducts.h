//
//  RequestDeliverProducts.h
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseDeliverProducts.h"

/**
 查询 拣货中/已发货 发货单商品
 */
@interface RequestDeliverProducts : HttpRequestBase

@property (nonatomic, assign) NSInteger pageno;
@property (nonatomic, assign) NSInteger pagesize;

@property (nonatomic, copy) NSString *liveid;
@property (nonatomic, copy) NSString *adorderid;    // 发货单ID，不传该参数，默认返回活动所有商品

@property (nonatomic, assign) NSInteger type;   // 1:拣货中 2：已发货


@end
