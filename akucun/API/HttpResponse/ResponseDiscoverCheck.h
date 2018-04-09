//
//  ResponseDiscoverCheck.h
//  akucun
//
//  Created by Jarry Z on 2018/3/21.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpResponseBase.h"

@interface ResponseDiscoverCheck : HttpResponseBase

@property (nonatomic, assign) BOOL isUpdated;

@property (nonatomic, strong) NSDictionary *flagData;

@end
