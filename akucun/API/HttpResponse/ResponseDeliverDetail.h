//
//  ResponseDeliverDetail.h
//  akucun
//
//  Created by Jarry on 2017/6/25.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpResponseBase.h"
#import "AdOrder.h"
#import "CartProduct.h"

@interface ResponseDeliverDetail : HttpResponseBase

@property (nonatomic, strong) AdOrder  *order;

@end
