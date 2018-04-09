//
//  RequestDirectBuy.h
//  akucun
//
//  Created by Jarry Zhu on 2017/11/5.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestDirectBuy : HttpRequestPOST

@property (nonatomic, copy)   NSString  *liveId;

@property (nonatomic, copy)   NSString  *productId;

@property (nonatomic, copy)   NSString  *skuId;

@property (nonatomic, copy)   NSString  *addrId;

@property (nonatomic, copy)   NSString  *remark;


@end
