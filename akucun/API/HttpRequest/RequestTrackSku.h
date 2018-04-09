//
//  RequestTrackSku.h
//  akucun
//
//  Created by Jarry Z on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "ResponseTrackSku.h"

@interface RequestTrackSku : HttpRequestBase

@property (nonatomic, copy)   NSString  *liveid;

@property (nonatomic, assign) double syncsku;

@end
