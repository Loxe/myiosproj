//
//  ResponseOrderDetail.h
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpResponseList.h"
#import "OrderModel.h"
#import "Logistics.h"

@interface ResponseOrderDetail : HttpResponseList

@property (nonatomic, strong) OrderModel  *order;
@property (nonatomic, strong) Logistics  *logistics;

@end
