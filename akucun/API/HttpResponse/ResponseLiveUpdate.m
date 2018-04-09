//
//  ResponseLiveUpdate.m
//  akucun
//
//  Created by Jarry Z on 2018/3/12.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ResponseLiveUpdate.h"
#import "LiveManager.h"

@implementation ResponseLiveUpdate

- (void) parseData:(NSDictionary *)jsonData
{
    [super parseData:jsonData];
    
    LiveInfo *liveInfo = [LiveInfo yy_modelWithDictionary:jsonData];
    [LiveManager updateLiveInfo:liveInfo];
}

@end
