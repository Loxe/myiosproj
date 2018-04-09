//
//  RequestUserLives.h
//  akucun
//
//  Created by Jarry Z on 2018/1/22.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseUserLives.h"

@interface RequestUserLives : HttpRequestBase

@property (nonatomic, assign) NSInteger pageno;
@property (nonatomic, assign) NSInteger pagesize;


@end
