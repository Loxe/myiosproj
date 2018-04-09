//
//  RequestLiveProducts.h
//  akucun
//
//  Created by Jarry Z on 2018/1/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseLiveProducts.h"

@interface RequestLiveProducts : HttpRequestBase

@property (nonatomic, copy)   NSString  *liveid;

@property (nonatomic, assign) NSInteger lastxuhao;

@end
