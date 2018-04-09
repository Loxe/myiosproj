//
//  RequestGetVideoInfo.h
//  akucun
//
//  Created by Jarry Z on 2018/4/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpRequestBase.h"
#import "VideoInfo.h"

@interface RequestGetVideoInfo : HttpRequestBase

@property (nonatomic, copy)   NSString  *videoId;

@end
