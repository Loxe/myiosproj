//
//  ResponseTrackSku.h
//  akucun
//
//  Created by Jarry Z on 2018/1/8.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "HttpResponseList.h"
#import "ProductSKU.h"

@interface ResponseTrackSku : HttpResponseList

@property (nonatomic, copy)   NSString  *liveid;
@property (nonatomic, assign) double lastupdate;

@property (nonatomic, assign) NSInteger period;

@end
