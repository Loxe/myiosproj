//
//  ServiceTypeManager.h
//  akucun
//
//  Created by deepin do on 2018/1/5.
//  Copyright © 2018年 Sucang. All rights reserved.
//


// 客服渠道类型
typedef NS_ENUM(NSInteger, ServiceType) {
    ServiceTypeNone = 0,     // 初始无服务
    ServiceTypeSale = 1,     // 售前咨询
    ServiceTypeFeed = 2,     // 售后咨询
};

#import <Foundation/Foundation.h>

@interface ServiceTypeManager : NSObject

@property(nonatomic, assign) ServiceType serviceType;

+ (ServiceTypeManager *)instance;

@end
