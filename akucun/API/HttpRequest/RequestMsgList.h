//
//  RequestMsgList.h
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseMsgList.h"

@interface RequestMsgList : HttpRequestBase

@property (nonatomic, assign) NSInteger pageno;

@property (nonatomic, assign) NSInteger pagesize;

@end
