//
//  ResponsePaytypes.h
//  akucun
//
//  Created by Jarry on 2017/6/19.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "HttpResponseList.h"
#import "PayType.h"

@interface ResponsePaytypes : HttpResponseList

- (NSArray *) validPayTypes;

@end
