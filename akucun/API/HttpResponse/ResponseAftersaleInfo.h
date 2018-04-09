//
//  ResponseAftersaleInfo.h
//  akucun
//
//  Created by Jarry on 2017/9/13.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpResponseBase.h"
#import "ASaleService.h"

@interface ResponseAftersaleInfo : HttpResponseBase

@property (nonatomic, strong) ASaleService *asaleService;

@end
