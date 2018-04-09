//
//  LiveProductController.h
//  akucun
//
//  Created by Jarry Zhu on 2017/12/21.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "ProductBaseController.h"

@interface LiveProductController : ProductBaseController

@property (nonatomic, copy) LiveInfo *liveInfo;

- (void) updateLive:(LiveInfo *)liveInfo;

@end
