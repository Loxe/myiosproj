//
//  RequestProductFollow.h
//  akucun
//
//  Created by Jarry on 2017/9/17.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestProductFollow : HttpRequestBase

@property (nonatomic, copy)   NSString  *productId;

// 1 是关注，其它是取消关注
@property (nonatomic, assign) NSInteger statu;

@end
