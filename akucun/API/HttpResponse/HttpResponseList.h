//
//  HttpResponseList.h
//  akucun
//
//  Created by Jarry on 14-7-2.
//  Copyright (c) 2014年 Sucang. All rights reserved.
//

#import "HttpResponseBase.h"

@interface HttpResponseList : HttpResponseBase

@property (nonatomic, strong) NSMutableArray  *result;    // 结果集
@property (nonatomic, assign) NSInteger       count;      // 总数

@property (nonatomic, assign) NSInteger       page;       // 页码
@property (nonatomic, assign) NSInteger       pages;      // 总页数


- (NSString *) resultKey;

- (id) parseItemFrom:(NSDictionary *)dictionary;

- (void) addResultList:(NSArray *)list;

- (BOOL) didReachEnd;

@end
