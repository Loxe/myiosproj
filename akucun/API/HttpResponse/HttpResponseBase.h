//
//  HttpResponseBase.h
//  akucun
//
//  Created by Jarry on 17/3/15.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "SCHttpResponse.h"

@interface HttpResponseBase : SCHttpResponse

- (void) parseData:(NSDictionary *)jsonData;

@end
