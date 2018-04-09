//
//  DiscoverViewController.h
//  akucun
//
//  Created by Jarry Zhu on 2017/11/9.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import "BaseViewController.h"

@interface DiscoverViewController : BaseViewController

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL shouldUpdate;

- (void) updateData:(voidBlock)finished;

@end
