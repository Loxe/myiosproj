//
//  RequestSearchProducts.h
//  akucun
//
//  Created by Jarry Z on 2018/2/1.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseUserProducts.h"

@interface RequestSearchProducts : HttpRequestBase

@property (nonatomic, copy)   NSString  *liveid;
@property (nonatomic, copy)   NSString  *info;

@end
