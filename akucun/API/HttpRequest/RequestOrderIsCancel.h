//
//  RequestOrderIsCancel.h
//  akucun
//
//  Created by Jarry Z on 2018/3/26.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestOrderIsCancel : HttpRequestBase

@property (nonatomic, copy) NSString *orderid;

@end
