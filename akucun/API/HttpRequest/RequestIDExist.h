//
//  RequestIDExist.h
//  akucun
//
//  Created by deepin do on 2017/12/22.
//  Copyright © 2017年 Sucang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestBase.h"

@interface RequestIDExist : HttpRequestPOST

@property (nonatomic, copy) NSString  *idcard;

@end
