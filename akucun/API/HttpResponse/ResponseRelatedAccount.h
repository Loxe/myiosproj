//
//  ResponseRelatedAccount.h
//  akucun
//
//  Created by Jarry Z on 2018/4/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpResponseBase.h"
#import "Member.h"

@interface ResponseRelatedAccount : HttpResponseBase

@property (nonatomic, strong) Member *member;
@property (nonatomic, assign) NSInteger checkStatus;

@end
