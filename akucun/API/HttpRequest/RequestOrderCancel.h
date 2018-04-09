//
//  RequestOrderCancel.h
//  akucun
//
//  Created by Jarry on 2017/4/20.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestOrderCancel : HttpRequestBase

@property (nonatomic, copy) NSString *orderid;

@end
