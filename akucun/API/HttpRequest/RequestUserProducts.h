//
//  RequestUserProducts.h
//  akucun
//
//  Created by Jarry Z on 2018/1/23.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseUserProducts.h"

@interface RequestUserProducts : HttpRequestBase

@property (nonatomic, copy)   NSString  *liveid;

@property (nonatomic, assign) NSInteger pageno;
@property (nonatomic, assign) NSInteger pagesize;

@end
