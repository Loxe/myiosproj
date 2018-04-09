//
//  RequestActiveCode.h
//  akucun
//
//  Created by Jarry Zhu on 2017/10/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestActiveCode : HttpRequestBase

@property (nonatomic, copy)   NSString  *referralcode;
@property (nonatomic, copy)   NSString  *ruserid;

@end
