//
//  RequestCheckFriend.h
//  akucun
//
//  Created by Jarry Z on 2018/4/7.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

/**
 查询是否有相互的好友关系
 */
@interface RequestCheckFriend : HttpRequestBase

@property (nonatomic, copy) NSString *mainDaigouid;

@end
