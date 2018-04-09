//
//  ServiceTypeManager.m
//  akucun
//
//  Created by deepin do on 2018/1/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//

#import "ServiceTypeManager.h"

@implementation ServiceTypeManager

+ (ServiceTypeManager *)instance {
    static dispatch_once_t  onceToken;
    static ServiceTypeManager * instance;
    dispatch_once(&onceToken, ^{
        instance = [[ServiceTypeManager alloc] init];
    });
    return instance;
}

@end
