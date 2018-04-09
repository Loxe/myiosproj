//
//  ResponseOrderCreate.h
//  akucun
//
//  Created by Jarry on 2017/5/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpResponseList.h"
#import "OrderModel.h"

@interface ResponseOrderCreate : HttpResponseList

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, strong) NSArray *orderids;

@end
