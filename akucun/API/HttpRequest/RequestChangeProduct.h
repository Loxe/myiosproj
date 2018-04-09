//
//  RequestChangeProduct.h
//  akucun
//
//  Created by Jarry on 2017/6/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestChangeProduct : HttpRequestBase

@property (nonatomic, copy)   NSString  *orderId;

@property (nonatomic, copy)   NSString  *productId;

@property (nonatomic, copy)   NSString  *skuId;

@end
