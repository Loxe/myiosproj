//
//  RequestUseCode.h
//  akucun
//
//  Created by Jarry Zhu on 2017/10/24.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"

@interface RequestUseCode : HttpRequestBase

@property (nonatomic, copy)   NSString  *referralcode;

@end
