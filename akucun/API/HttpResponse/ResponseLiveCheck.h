//
//  ResponseLiveCheck.h
//  akucun
//
//  Created by Jarry Z on 2018/3/24.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpResponseBase.h"

@interface ResponseLiveCheck : HttpResponseBase

@property (nonatomic, strong) NSDictionary *flagData;
@property (nonatomic, assign) BOOL isLiveUpdated;

@end
