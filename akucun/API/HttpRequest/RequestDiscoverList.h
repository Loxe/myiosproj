//
//  RequestDiscoverList.h
//  akucun
//
//  Created by Jarry Zhu on 2017/11/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseDiscoverList.h"

@interface RequestDiscoverList : HttpRequestBase

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger pageno;
@property (nonatomic, assign) NSInteger pagesize;

@end
