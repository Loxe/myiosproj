//
//  DeviceIDManager.h
//  akucun
//
//  Created by Jarry on 2017/9/26.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceIDManager : NSObject


/**
 Vender ID UUID
 */
+ (NSString *) IDFVString;

+ (void) deleteIDFV;

@end
