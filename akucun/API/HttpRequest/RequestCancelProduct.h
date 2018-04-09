//
//  RequestCancelProduct.h
//  akucun
//
//  Created by Jarry Z on 2018/1/22.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestCancelProduct : HttpRequestBase

@property (nonatomic, copy) NSString *orderid;
@property (nonatomic, copy) NSString *cartproductid;

@end
