//
//  RequestDeliverApply.h
//  akucun
//
//  Created by Jarry on 2017/7/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

/**
 申请临时对帐单
 */
@interface RequestDeliverApply : HttpRequestBase

@property (nonatomic, copy) NSString *adorderid;
@property (nonatomic, copy) NSString *liveid;

@end
