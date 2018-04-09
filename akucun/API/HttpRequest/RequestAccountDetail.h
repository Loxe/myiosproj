//
//  RequestAccountDetail.h
//  akucun
//
//  Created by Jarry on 2017/6/18.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseAccountDetail.h"

@interface RequestAccountDetail : HttpRequestBase

@property (nonatomic, assign) NSInteger pageno;

@property (nonatomic, assign) NSInteger pagesize;

@end
