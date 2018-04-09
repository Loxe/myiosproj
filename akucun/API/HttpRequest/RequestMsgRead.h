//
//  RequestMsgRead.h
//  akucun
//
//  Created by Jarry on 2017/6/29.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestMsgRead : HttpRequestBase

@property (nonatomic, copy) NSString *msgid;

@end
