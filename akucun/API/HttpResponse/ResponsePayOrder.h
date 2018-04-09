//
//  ResponsePayOrder.h
//  akucun
//
//  Created by Jarry on 2017/5/7.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpResponseBase.h"
#import "OrderModel.h"

@interface ResponsePayOrder : HttpResponseBase

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, strong) id payInfo;

@property (nonatomic, copy) NSString *paymentId;

@end
