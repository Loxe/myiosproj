//
//  ResponseSubuserList.h
//  akucun
//
//  Created by Jarry Zhu on 2018/1/3.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpResponseList.h"
#import "SubUser.h"

@interface ResponseSubuserList : HttpResponseList

@property (nonatomic, strong) SubUser *phoneAccount;

@end
