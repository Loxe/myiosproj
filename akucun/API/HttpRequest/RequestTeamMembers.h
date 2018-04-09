//
//  RequestTeamMembers.h
//  akucun
//
//  Created by deepin do on 2018/1/19.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestBase.h"

@interface RequestTeamMembers : HttpRequestBase

@property (nonatomic, assign) NSInteger pageno; //当前页
@property (nonatomic, assign) NSInteger pagesize; //总页数

@property (nonatomic, copy) NSString *vipfalg;

@end
