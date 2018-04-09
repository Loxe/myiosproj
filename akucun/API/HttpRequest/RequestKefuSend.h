//
//  RequestKefuSend.h
//  akucun
//
//  Created by Jarry on 2017/9/10.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestKefuSend : HttpRequestPOST

@property (nonatomic, copy) NSString *content;

@end
