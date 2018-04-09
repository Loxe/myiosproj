//
//  RequestProductBuy.h
//  akucun
//
//  Created by Jarry on 2017/4/8.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestProductBuy : HttpRequestBase

@property (nonatomic, copy)   NSString  *productId;

@property (nonatomic, copy)   NSString  *skuId;

@property (nonatomic, copy)   NSString  *remark;

@property (nonatomic, copy)   NSString  *cartproductid;

@end
