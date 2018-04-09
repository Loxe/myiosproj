//
//  RequestRelatedUserList.h
//  akucun
//
//  Created by Jarry Z on 2018/4/4.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseRelatedUserList.h"

@interface RequestRelatedUserList : HttpRequestBase

@property (nonatomic, copy) NSString *month;    // 年月 格式 ：2018-01

@end
