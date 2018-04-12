//
//  RequestDeliverSearch.h
//  akucun
//
//  Created by Jarry Z on 2018/4/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseDeliverProducts.h"

@interface RequestDeliverSearch : HttpRequestBase

@property (nonatomic, assign) NSInteger pageno;
@property (nonatomic, assign) NSInteger pagesize;

@property (nonatomic, copy) NSString *liveid;
@property (nonatomic, assign) NSInteger type;   // 1:拣货中 2：已发货

@property (nonatomic, copy) NSString *barcode;  // 搜索条码
@property (nonatomic, copy) NSString *charcater; // 搜索备注、款号、描述等

@end
