//
//  ResponseRelatedUserList.h
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpResponseList.h"
#import "Member.h"

@interface ResponseRelatedUserList : HttpResponseList

@property (nonatomic, assign) double totalSales;
@property (nonatomic, assign) double accountSales;
@property (nonatomic, assign) double shadowSales;

@end
