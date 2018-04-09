//
//  RequestAftersaleTuihuo.h
//  akucun
//
//  Created by Jarry on 2017/9/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestAftersaleTuihuo : HttpRequestPOST

@property (nonatomic, copy) NSString *cartproductid;

@property (nonatomic, copy) NSString *refundcorp;
@property (nonatomic, copy) NSString *refundhao;

@end
